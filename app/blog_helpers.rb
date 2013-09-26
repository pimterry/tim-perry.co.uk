require_relative './model/blog'

def get_posts date_components = [], title = nil
  # Strip out any nils from the date_components
  date_components.reject! { |x| x == nil }
  date_components.collect! { |x| x.to_i }

  posts = Post.all(:order => [:posted_at.desc])

  if date_components.length != 0 then
    start_date = DateTime.new(*date_components)
    start_date -= 1.0 / 24 / 60 / 60

    end_date_params = date_components

    # Increment the last component of the date: so if they specify year
    # and month, we go from (02/2012) to (03/2012).
    end_date_params[-1] += 1
    end_date = DateTime.new *end_date_params

    posts = posts.all(:posted_at => (start_date .. end_date))
  end

  if title != nil then
    posts = posts.all(:encoded_title => Post.encode_title(title))
  end

  return posts
end

def get_single_post year, month, day, title
  posts = get_posts([year, month, day], title)

  if posts.length != 1 then
    raise ArgumentError, "Found #{posts.length} posts, wanted just one."
  elsif not authorized? and not posts[0].published?
    raise ArgumentError, "No published posts found"
  end

  posts[0]
end
