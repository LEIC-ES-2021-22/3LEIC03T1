Feature: Reserve a Book
  Tests regarding the book reservation feature

  Scenario: Choosing to reserve a book
    Given I open the drawer
    And I navigate to the "librarySearch" page
    And I pause for 15 seconds
    And I fill the "searchBar" field with "The narrative"
    And I tap the "search" icon
    And I wait until the widget of type "CircularProgressIndicator" is absent
    And I tap the first descendant of "searchFeedColumn" of type "BookContainer"
    When I tap the "reserveBook" button
    Then I expect the text "Reserva do Livro" to be present
