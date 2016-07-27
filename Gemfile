source 'https://rubygems.org'

gem 'rake'
gem 'sinatra'

gem 'haml'
gem 'RedCloth'
gem 'hpricot'
gem 'coderay'
gem 'xml-sitemap'
gem 'rack-canonical-host'

gem 'datamapper'

group :local_test do
  gem 'rack-test'
  gem 'rspec'
end

group :integration_test do
  gem 'cucumber'
  gem 'watir-webdriver'
end

group :development do
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'newrelic_rpm'
  gem 'puma'
end
