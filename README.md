# Aspiration

This project has been my aspiration, hence, the name of the repo. The design is simple where I take the Zomato API to fetch nearby restaurants for the cuisine you have selected. So, initially it asks for the city you want to search for and that will be the city you reside in because you're searching for something nearby. When it gives you a cuisine suggestion list, you search for your the cuisine you are craving for and go to the next page where the restaurants are shown in a map as well as list view. On selecting the map or list views, you are taken to Zomato's url which contains the menu of the restaurant.

**Step 1** - Clone the repository or download the zip file and open the workspace in xcode
-- git clone --
**Step 2** - On running the application, it first asks you to give your city name, so that appropriate cuisine suggestions can be provided
**Step 3** - On selecting the cuisine suggestion, it directs you to the map view where the pins tell you more abot the restaurant's location and other details
**Step 4** - You can change the view to list view where the restaurants are listed in a table view

Note - The details of each location and the restaurants along with the cuisine are stored in core data once they are retrieved from the API.
