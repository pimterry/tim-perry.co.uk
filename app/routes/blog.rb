require_relative '../model/blog'
require 'hpricot'

CAPTCHA_VALUE = 4

class TimPerryApp < Sinatra::Base
  get %r{/blog/(\d{4})/(\d{2})/(\d{2})/([\w\d_]+)/?} do |year, month, day, title|
    show_posts get_posts([year, month, day], title)
  end

  get %r{/blog/(\d{4})/(\d{2})/(\d{2})/} do |year, month, day|
    show_posts get_posts([year, month, day])
  end

  get %r{/blog/(\d{4})/(\d{2})/} do |year, month|
    show_posts get_posts([year, month])
  end

  get %r{/blog/(\d{4})/} do |year|
    show_posts get_posts([year])
  end

  get %r{^/blog/?$} do
    show_posts get_posts
  end

  get '/blog/rss' do
    content_type 'application/atom+xml'

    posts = Post.filter_by_published get_posts

    last_updated = posts[0].posted_at.to_s

    haml :rss, :format => :xhtml, :escape_html => true, :layout => false,
          :locals => { :title => "Tim Perry (etc.)",
                       :post_root => "http://oldblog.tim.fyi",
                       :feed_updated => last_updated,
                       :posts => posts }
  end
end

def show_posts posts
  unless authorized?
    posts = Post.filter_by_published posts
  end

  if posts.length == 1 then
    post = posts[0]
    if request.path_info != post.url then
      redirect post.url, 301
    else
      render_single_post_page post
    end

  elsif posts.length > 1 then
    render_posts_page posts

  else
    haml :template, :locals => { :title => "No posts found",
                                 :paragraphs => [] }
  end
end

def render_posts_page posts
  posts = posts.map { |p| PostIntro.new(p, authorized?) }

  sidebar = Paragraph.new("What's this?",
                          textile(:'partials/sidebar'))

  haml :template, :locals => { :title      => "Blog",
                               :paragraphs => posts,
                               :sidebar    => sidebar }
end

def render_single_post_page post
  haml :template, :locals => {:title => "Blog",
                              :paragraphs => [post],
                              :update_time => post.posted_at}
end

class PostIntro
  include Sinatra::Delegator

  def initialize(post, admin_style = false)
    @post = post
    @admin_style = admin_style
  end

  def method_missing(method, *args)
    args.empty? ? @post.send(method) : @post.send(method, args)
  end

  def heading_html
    @post.heading_html
  end

  def content_html
    html = Hpricot.parse(@post.content_html)
    first_paragraph = (html/:p).first.to_html
    first_paragraph += "<p><a href='#{@post.url}'>Read this post</a>"

    if @admin_style then
      first_paragraph += "<form action='#{@post.url}/delete' method='post'>" +
        "<input type='hidden' name='id' value='#{@post.id}' />" +
        "<input type='submit' value='Delete post' />" +
      "</form>"
    end

    first_paragraph += "</p>"
  end
end
