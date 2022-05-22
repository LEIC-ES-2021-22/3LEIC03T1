Feature: Reservation History
  Tests regarding the reservation history functionality

  Scenario: See Reservation History
    Given I open the drawer
    And I navigate to the "librarySearch" page
    When I tap the "reservationsButton" button
    Then I expect the button "catalogButton" to be present within 2 seconds
