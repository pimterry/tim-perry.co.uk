require 'sinatra'
require 'rack/test'

require './app/app'

module ComponentTests
  describe "The blog page" do
    include Rack::Test::Methods

    before(:each) do
      ENV['DATABASE_URL'] = 'sqlite::memory:'
    end

    def app
      TimPerryApp
    end

    it "loads successfully" do
      get '/blog'
      expect(last_response).to be_ok
    end
  end
end