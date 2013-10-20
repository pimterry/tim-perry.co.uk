require 'rspec/expectations'
require 'watir-webdriver'
require_relative '../pages/site'
require_relative '../pages/blog'

if ENV['WEBDRIVER_URL'] then
  browser = Watir::Browser.new(:remote, :url => ENV['WEBDRIVER_URL'])
else
  browser = Watir::Browser.new(:phantomjs)
end

puts "\nWebDriver browser loaded\n\n"

Before do
  root_url = ENV['INTEGRATION_TEST_TARGET']
  @site = TimPerrySite.new(browser, root_url)
  @site.load(BlogPage)
end

at_exit do
  browser.close
end
