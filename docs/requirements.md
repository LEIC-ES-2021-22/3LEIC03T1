
## Requirements

### Use case model 

 <p align="center" justify="center">
  <img src="../images/UseCaseView.png"/>
</p>

|||
| --- | --- |
| *Name* | Search Library's Catalog |
| *Actor* |  UP Member | 
| *Description* | The UP member can search for the books he wants, through filters and text search, from the library's catalog. |
| *Preconditions* | - The user is logged in. <br> - The input of the user is not empty. |
| *Postconditions* | - The application shows all the results found by the search. <br> |
| *Normal flow* | 1. The UP member accesses the book search page. <br> 2. The application shows the possible search filters, including a text ba.r <br> 3. The UP member inserts the filters they want to search for.<br> 4. The UP member executes the action to search.<br> 5. The application redirects the user to the Search Results Page. |
| *Alternative flows and exceptions* | 1. [Empty Input] If the UP member didn't insert any input, step 5 of the normal flow will not be executed and a warning will be displayed. <br> 2. [Library API Error] If the Library API returns any error in the results, a warning with the error's description will be displayed to the user. Step 5 of the normal flow will not be executed. |

|||
| --- | --- |
| *Name* | See Book Details |
| *Actor* |  UP Member |
| *Description* | The UP member can check the book details, such as author, publisher, publish date and number of pages. |
| *Preconditions* | - The user is logged in. |
| *Postconditions* | - The application displays the requested book details. |
| *Normal flow* | 1. The UP member selects the book from within the results previously presented.<br> 2. The application display a page with the book details. |
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user and step 2 of the normal flow will not be executed. |

|||
| --- | --- |
| *Name* | Request Book Reservation |
| *Actor* |  UP Member | 
| *Description* | The UP member can make a request to reserve a book from the library |
| *Preconditions* | - The user is logged in. <br> - The book they want to reserve is available in their faculty's library. <br> - The UP member is not restricted from using the library's services |
| *Postconditions* | - The book will be added to the reservation requests of the UP member. <br> - When the reservation is accepted, the book will no longer be available. |
| *Normal flow* | 1. The UP member will insert the desired dates of the beginning and end of the book's reservation.<br> 2. The UP member confirms the reservation request.<br> 3. The app shows a confirmation that the reservation was done successfully. |
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user and step 3 of the normal flow will not be executed.|

|||
| --- | --- |
| *Name* | Download Digital Version |
| *Actor* |  UP Member | 
| *Description* | The UP member can download the digital version of a book |
| *Preconditions* | - The user is logged in. <br> - The book has a digital version available |
| *Postconditions* | - The user is redirected to a webpage where they can download the book  |
| *Normal flow* | 1. From the book details page, the user clicks on a *E-Book* button <br> 2. The application redirects the user to a webpage where they can download the digital book |
| *Alternative flows and exceptions* | 1. If the URL provided by the library is not functional, the user will not be able to download the book's digital version |


|||
| --- | --- |
| *Name* | See Reservation History |
| *Actor* |  UP Member | 
| *Description* | The UP member can see their history of reservations, including the active ones.|
| *Preconditions* | - The user is logged in. <br>|
| *Postconditions* | - The application presents information about the user's reservations, such as the title of the book, reservation start date and return date |
| *Normal flow* | 1. The UP member accesses the reservation history page.<br> 2. The application displays the list of books reserved by the UP member<br>|
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user and step 2 of the normal flow will not be executed.|

|||
| --- | --- |
| *Name* | See Book Reservation Details |
| *Actor* |  UP Member | 
| *Description* | The UP member can verify the reservation details such as the book's title, return date and check if it's renewable or cancelable |
| *Preconditions* | - The user is logged in. <br> - The user has a reservation history|
| *Postconditions* | - The application displays information about the book reservation |
| *Normal flow* | 1. The UP member accesses the reservation history page. <br> 2. The UP member will click in the desired reservation.<br> 3. The application displays the details regarding the book reservation.
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user and step 3 of the normal flow will not be executed.|

|||
| --- | --- |
| *Name* | Cancel Reservation Request |
| *Actor* |  UP Member | 
| *Description* | The UP member can cancel a reservation request |
| *Preconditions* | - The user is logged in. <br> - The UP member hasn't picked up the book yet. <br>|
| *Postconditions* | - The book reservation request is cancelled. |
| *Normal flow* | 1. The UP member accesses the book reservation details page. <br> 2. The UP member clicks the *Cancel Reservation* button. <br> 3. The application displays a confirmation pop-up. <br> 4. The user clicks in the confirm button of the pop-up. <br> 5. The user is redirected to the Reservation History page.
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user and step 5 of the normal flow will not be executed.|

|||
| --- | --- |
| *Name* | Renew Reservation |
| *Actor* |  UP Member | 
| *Description* | The UP member can renew a reservation |
| *Preconditions* | - The user is logged in. <br> - The UP member is not restricted from using the library's services <br> - The book is still available for reservations |
| *Postconditions* | - The book reservation is renewed and the return date is updated |
| *Normal flow* | 1. The UP member accesses the book reservation details page. <br> 2. The UP member clicks the *Renew Reservation* button. <br> 3. The application displays a confirmation pop-up. <br> 4. The user clicks in the confirm button of the pop-up. <br> 5. The user is redirected to the Reservation History page.
| *Alternative flows and exceptions* | 1. [Library API Error] If the Library API returns any error in the results, a warning with the error’s description will be displayed to the user, the reservation will not be renewed and step 5 of the normal flow will not be executed |

### Domain model

 <p align="center" justify="center">
  <img src="../images/DomainModel.png"/>
</p>
