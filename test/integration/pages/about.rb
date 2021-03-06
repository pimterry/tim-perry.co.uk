class AboutPage
  def initialize(browser, root_url)
    @browser = browser
    @root_url = root_url
  end

  def load
    @browser.goto "#{@root_url}/about"
  end

  def is_loaded
    @browser.html.include? "About Me"
  end
end
