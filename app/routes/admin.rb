class TimPerryApp < Sinatra::Base
  admin_pages = { "New Post" => "/blog/new_post",
                  "Manage Posts" => "/blog/manage_posts",
                  "Log Out" => "/admin/logout" }

  get '/admin' do
    protected!

    admin_list = Paragraph.new("Admin Pages",
                    haml(:"partials/admin_pages",
                         :locals => { :pages => admin_pages }))

    haml :template, :locals => { :title => "Admin",
                                 :paragraphs => [admin_list] }
  end

  # New blog-posting pages
  get '/blog/new_post' do
    protected!

    post_input_paragraph = Paragraph.new("Write a new post",
                                   haml(:"partials/post_admin"))

    haml :template, :locals => { :title => "Blog",
                                 :paragraphs => [post_input_paragraph]}
  end

  post '/blog' do
    protected!

    if params[:id] then
      post = Post.get(params[:id])
    else
      post = Post.new
    end

    post.title = params[:title]
    post.content = params[:content]
    post.posted_at = DateTime.parse(params[:posting_date])
    post.save

    redirect post.url
  end

  # Managing blog postings
  get '/blog/manage_posts' do
    protected!

    raise NotImplementedError
  end

  get %r{/blog/(\d{4})/(\d{2})/(\d{2})/([\w\d_]+)/edit} do |year, month, day, title|
    protected!

    postedDate = DateTime.new(year.to_i, month.to_i, day.to_i)

    posts = Post.all(:posted_at    => (postedDate .. postedDate + 1),
                     :encoded_title => title,
                     :order => [:posted_at.desc]) or [];

    if posts.length == 1 then
      post_input_paragraph = Paragraph.new("Edit post",
                               haml(:"partials/post_admin",
                                    :locals => { :postObj => posts[0] }))

      haml :template, :locals => { :title => posts[0].title,
                                   :paragraphs => [post_input_paragraph] }

    else
      haml :template, :locals => { :title => "Found #{posts.length} posts",
                                   :paragraphs => [] }
    end
  end

  post %r{/blog/(\d{4})/(\d{2})/(\d{2})/([\w\d_]+)/delete} do |year, month, day, title|
    protected!

    post = get_single_post(year, month, day, title)
    post.destroy

    redirect post.url
  end

  get %r{/blog/(\d{4})/(\d{2})/(\d{2})/([\w\d_]+)/comments/(\d+)/delete} do |year, month, day, title, comment_id|
    protected!

    post = get_single_post(year, month, day, title)
    comment = Comment.get(comment_id)

    if comment.post != post then
      raise ArgumentError, "Trying to delete comment, but specified wrong post"
    end

    comment.destroy
    redirect "#{post.url}#comments"
  end

  get '/admin/login' do
    login_form = Paragraph.new("Please log in",
                               haml(:"partials/login",
                                    :locals => { :action => '/admin/login' }))

    haml :template, :locals => { :title => "Admin login",
                                 :paragraphs => [ login_form ] }
  end

  post '/admin/login' do
    if params[:username] && params[:password] then
      login_as params[:username], params[:password]
    end

    protected!

    redirect '/admin'
  end

  get '/admin/logout' do
    logout
    redirect '/'
  end
end