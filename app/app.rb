require 'sinatra'

class TimPerryApp < Sinatra::Base
  set :app_file, __FILE__

  configure :development do
    enable :dump_errors
    enable :raise_errors
  end

  configure :production do
    require 'newrelic_rpm'
  end

  require_relative './blog_helpers'
  require_relative './rendering_helpers'
  require_relative './auth_helpers'
  require_relative './model/init'
  require_relative './routes/init'

  def initialize(app = nil)
    super(app)
  end
end
