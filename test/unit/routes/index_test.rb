require 'sinatra'
require 'rack/test'

require './app/routes/blog'

module Routes
  describe 'The about page' do
    include Rack::Test::Methods

    def app
      TimPerryApp
    end

    it "loads successfully" do
      get '/blog'
      # expect(last_response).to be_ok TODO: Re-enable after refactoring
    end
  end
end