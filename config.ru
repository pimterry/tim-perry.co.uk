require './app/app'

require 'rack-canonical-host'
use Rack::CanonicalHost, ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']

run TimPerryApp
