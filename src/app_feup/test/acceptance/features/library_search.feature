Feature: Library Search
  Tests regarding the library search functionality

  Scenario: Search for books
    Given I open the drawer
    And I navigate to the "librarySearch" page
    When I fill the "searchBar" field with "C++"
    And I tap the "search" icon
    And I wait until the widget of type "CircularProgressIndicator" is absent
    Then I expect the text "C++" to be present
    # Replace this test with another one, this is impossible to test properly
