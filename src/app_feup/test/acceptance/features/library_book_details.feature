Feature: Book Details
  Tests regarding the library book details functionality

  Scenario: See Book Details
    Given I open the drawer
    And I navigate to the "librarySearch" page
    # This is needed because the flutter_gherkin isn't overriding the timeout
    And I pause for 15 seconds
    And I wait until the widget of type "CircularProgressIndicator" is absent
    When I tap the first descendant of "searchFeedColumn" of type "BookContainer"
    # Author is only present in details page
    Then I expect the text "Detalhes do Livro" to be present
