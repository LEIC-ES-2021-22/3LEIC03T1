Feature: Reservation Details
  Tests regarding the library reservation details functionality

  # TODO Needs to be changed once library is connected to it
  Scenario: See Reservation Details
    Given I open the drawer
    And I navigate to the "librarySearch" page
    And I tap the "reservationsButton" button
    And I tap the widget that contains the text "Programming - principles and practice using C++"
    # Author is only present in details page
    Then I expect the text "Stroustrup, Bjarne" to be present
