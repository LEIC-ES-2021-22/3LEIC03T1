Feature: Reservation Details
  Tests regarding the library reservation details functionality

  Scenario: See Reservation Details
    Given I open the drawer
    And I navigate to the "librarySearch" page
    And I tap the "reservationsButton" button
    And I wait until the widget of type "CircularProgressIndicator" is absent
    When I tap the first descendant of "reservationsFeedColumn" of type "ReservationContainer"
    # Author is only present in details page
    Then I expect the text "Detalhes da Reserva" to be present
