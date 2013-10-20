require_relative '../pages/blog'
require_relative '../pages/projects'
require_relative '../pages/about'

When(/^the blog page is loaded directly$/) do
  @home = @site.load(BlogPage)
end

When(/^the projects page is loaded directly$/) do
  @home = @site.load(ProjectsPage)
end

When(/^the about page is loaded directly$/) do
  @home = @site.load(AboutPage)
end

Then(/^a successful response is received$/) do
  @home.is_loaded.should be_true
end
