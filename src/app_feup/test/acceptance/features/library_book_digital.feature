Feature: Library Book Digital Version
  Tests regarding the library book's digital version feature

  Scenario: Download Digital Version
    Given I open the drawer
    And I navigate to the "librarySearch" page
    And I pause for 15 seconds
    And I fill the "searchBar" field with "Python"
    And I tap the "search" icon
    #And I pause for 5 seconds
    And I wait until the widget of type "CircularProgressIndicator" is absent
    When I tap the first descendant of "searchFeedColumn" of type "BookContainer"
    Then I expect the widget "downloadButton" to be present within 2 seconds
