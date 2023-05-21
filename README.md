# AllNewPlanets

# Features

- The app supports a minimum iOS version of 15.0.

- It loads data from the API: https://swapi.co/api/planets. Download the list of planets and display the list of planet names from the first page of planet data.

- Planet data is stored using Core Data and is persistent for offline viewing.

- Every time the app opens, it will download and update coredata.

- Run on both iPhones and iPads

- Unit testing has been added.

- only used the standard Apple iOS frameworks.



# Recommendations for future features and improvements.

1. UI and Feature

- Currently, the app just shows the planet name in the table. For further improvement, we can show planet properties like climate, terrain, etc. in a section in table view.

- Pagination can be implemented to load all the planet pages one by one.

- For further updates, we can introduce films, people, species, starships, and vehicles to the app.

- The UI can be redesigned, and one suggestion is to introduce a new home screen with tab view, one tab for each object, and show the overall list of these objects on each tab.

- Every new feature and update should be customer-facing, and we should consider user needs at each stage of the update.

- New flow coordinators can be added for each scene.

2. Core Data

- Core Data implementation presently supports the planet; however, planets have relationships to two other objects: residents and films. Both of these objects also contain relationships to other objects, such as characters, starships, species, vehicles, etc. Future development should look to include these objects and would need an updated data model for all these objects, including people and film.

  
4. Core Data Sync

- Every individual object has a created and edited date. So I would recommend that the coredata sync or update be based on the date changes. This can be performed at app launch and can be added as a setting in a separate UI to sync.

  
5. Unit Tesing

- Unit testing should be added for the data part, especially for persistent storage. 

