# X-Plane Live GoogleMaps GPS Tracker

iPad X-Plane flight tracker to enhance the experience of Bush flying. 
XMap displays X-Plane live aircraft position on your iPad using Google maps.

![Screenshot](Screenshot.jpeg)

### Create GoogleMaps API Key
[Getting an API Key](https://developers.google.com/maps/documentation/ios-sdk/get-api-key)

Don't forget to visit [Dashboard](https://console.cloud.google.com/apis/dashboard?project=xmap-298021&supportedpurview=project) and enable GoogleMaps API

Restrict your API key to iOS apps and GoogleMapsAPI

### Create file named SDKConstants.swift with the contents below:
```
import Foundation

struct SDKConstants {
   static let APIKey = "<YOUR_GOOGLE_MAPS_API_KEY>"
}
```

### Configure X-Plane to share UDP data

Launch the XMap app and observe IP address and port number eg. 192.168.0.43:49003 on the main screen.
Run X-Plane go to Settings -> Data Output, check rows 19 and 20 under Network via UDP column.
Check Send network data output and enter iPad IP address and port eg. 192.168.0.43 port 4903.

Tested on X-Plane 11.5

### Other Resources

https://developers.google.com/maps/documentation/ios-sdk/start#install-manually   
https://developers.google.com/maps/billing/gmp-billing?hl=en_US#maps-product   
https://console.cloud.google.com/google/maps-apis/metrics?project=xmap-298021&folder=&organizationId=&supportedpurview=project   
