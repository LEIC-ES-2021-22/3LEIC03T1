Feature: Library Search
  Tests regarding the library search functionality

  Scenario: Search for books
    Given I open the drawer
    And I navigate to the "librarySearch" page
    When I fill the "searchBar" field with "C++"
    And I tap the "search" icon
    Then I expect the text "Programming - principles and practice using C++" to be present
