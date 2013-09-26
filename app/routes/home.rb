class TimPerryApp < Sinatra::Base
  get '/' do
    redirect '/blog'
  end
end
