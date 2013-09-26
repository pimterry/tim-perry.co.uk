require_relative '../model/blog'
require 'xml-sitemap'

class TimPerryApp < Sinatra::Base
  get '/sitemap.xml' do
    map = XmlSitemap::Map.new('tim-perry.co.uk') do |m|
      m.add '/blog'
      m.add '/about'
      Post.all.each do |post|
        m.add post.url
      end
    end

    content_type 'text/xml'
    map.render
  end
end