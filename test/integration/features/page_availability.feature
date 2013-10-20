Feature: Pages are available and load successfully
  Scenario: Blog Page
    When the blog page is loaded directly
    Then a successful response is received

  Scenario: Projects Page
    When the projects page is loaded directly
    Then a successful response is received

  Scenario: About Page
    When the about page is loaded directly
    Then a successful response is received
