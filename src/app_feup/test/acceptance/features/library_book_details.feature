Feature: Book Details
  Tests regarding the library book details functionality

  Scenario: See Book Details
    Given I open the drawer
    And I navigate to the "librarySearch" page
    And I wait until the widget of type "CircularProgressIndicator" is absent
    # There's something preventing us from comparing the book titles
    And I tap the widget that contains the text "Os fogos da casa"
    # Author is only present in details page
    Then I expect the text "Detalhes do Livro" to be present
