require 'haml'

puts "loading routes init"

require_relative 'home'
require_relative 'admin'
require_relative 'blog'
require_relative 'about'
require_relative 'projects'
require_relative 'sitemap'
require_relative 'error'

class Paragraph
  def initialize heading_html, content_html
    @heading_html = heading_html
    @content_html = content_html
  end
  def heading_html
    @heading_html
  end
  def content_html
    @content_html
  end
end

def haml_view view, locals
  haml view, locals
end
