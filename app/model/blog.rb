require 'data_mapper'
require_relative '../rendering_helpers'

class Post
  include DataMapper::Resource

  property :id,            Serial
  property :title,         String,   :length => 100
  property :encoded_title, String,   :length => 100
  property :content,       Text,     :lazy    => false
  property :hits,          Integer,  :default => 0
  property :posted_at,     DateTime, :default => lambda { |r, p| DateTime.now }

  has n, :comments

  before :save do
    self.encoded_title = Post.encode_title self.title
  end

  # Encodes the title of a post into the form it will appear in in all urls:
  # lowercase, special characters removed, spaces as underscores.
  def self.encode_title title
    title.gsub(/[^\w\d ]/,'').gsub(/ +/, '_').downcase
  end

  def url
    "/blog/#{self.posted_at.strftime('%Y/%m/%d')}/#{self.encoded_title}"
  end

  def published?
    self.posted_at <= DateTime.now
  end

  def self.filter_by_published posts
    posts.all(:posted_at.lt => Time.now)
  end

  def heading_html
    self.title
  end

  def content_html
    render_textile(self.content)
  end
end

class Comment
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   :default => "Anonymous"
  property :link,       URI
  property :content,    Text,     :required => true
  property :posted_at,  DateTime, :default => Time.now

  belongs_to :post

  def heading_html
    "<strong>#{self.name}</strong> " +
      self.posted_at.strftime('at %I:%M%p on %d/%m/%Y')
  end

  def content_html
    render_textile(self.content)
  end

  def delete_url
    "#{self.post.url}/comments/#{self.id}/delete"
  end
end
