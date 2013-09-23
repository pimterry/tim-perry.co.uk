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

  require_relative 'model/init'

  def initialize(app = nil)
    super(app)
  end

  require_relative './routes/init.rb'
end
