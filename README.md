
1. Here I've used the Moya for the network calls.
2. integrated the Moya using swift packages.
3. To get the weather forecast details Used weatherapi (https://www.weatherapi.com)
4. I used MVVM architecture to manage all the dependency between the view, viewModel and model.
5. I also used the CoreLocation apple native framework to get the current location coordinates and used Geocoding to get the entered/search city coordinates.
6. Here I've created the LocalPersistentManager to store the last location details and for use offline.
7. Created NetworkMonitor to get the current device status of network, If it's offline showing last location details.
8. I also added the test case using native XCTest framework.
