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
                       :post_root => "http://tim-perry.co.uk",
                       :feed_updated => last_updated,
                       :posts => posts }
  end

  post %r{/blog/(\d{4})/(\d{2})/(\d{2})/([\w\d_]+)/?} do |year, month, day, title|
    post = get_single_post(year, month, day, title)

    if params[:bot_detector] == "#{CAPTCHA_VALUE}" then
      post.comments.create(:name    => params[:name],
                           :link    => params[:link],
                           :content => params[:content])
    end

    redirect "#{post.url}#comments"
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

  haml :template, :locals => { :title      => "Blog",
                               :paragraphs => posts,
                               :sidebar    => Paragraph.new("What's this?",
     "<p>This is the blog of <strong>Tim Perry</strong>. I make things " +
     "on computers, it's mostly in that sort of vein.</p>" +
     "<p>For more information, try the <a href='/about'>About Me</a> page, "+
     "or just start reading things.")}
end

def render_single_post_page post
  comments_html = haml :"partials/comments", :locals =>
                          { :comments => Comment.all(:post => post),
                            :comment_post_url => post.url,
                            :captcha_value => CAPTCHA_VALUE }

  comments_block = Paragraph.new("<a class='anchor' name='comments'>Comments</a>",
                                 comments_html)

  haml :template, :locals => {:title => "Blog",
                              :paragraphs => [post,
                                              comments_block],
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

    comment_count = @post.comments.length
    if comment_count > 0 then
      first_paragraph += " (or skip down to the <a href='#{@post.url}#comments'>" +
                           "#{comment_count} comment#{'s' if comment_count > 1}</a>)"
    end

    if @admin_style then
      first_paragraph += "<form action='#{@post.url}/delete' method='post'>" +
        "<input type='hidden' name='id' value='#{@post.id}' />" +
        "<input type='submit' value='Delete post' />" +
      "</form>"
    end

    first_paragraph += "</p>"
  end
end
