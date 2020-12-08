// https://developers.google.com/maps/documentation/ios-sdk/start#install-manually
// https://developers.google.com/maps/billing/gmp-billing?hl=en_US#maps-product
// https://console.cloud.google.com/google/maps-apis/metrics?project=xmap-298021&folder=&organizationId=&supportedpurview=project
import GoogleMaps
import UIKit

class ViewController: UIViewController, GMSMapViewDelegate {
   @IBOutlet private weak var mapView: GMSMapView!
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      mapView.camera = GMSCameraPosition.camera(withLatitude: 44.7866, longitude: 20.4489, zoom: 13.0)
      
      // Creates a marker in the center of the map.
      
      let airplane = UIImage(systemName: "airplane")
      let markerView = UIImageView(image: airplane)
      markerView.frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
      markerView.tintColor = .red
      
      let marker = GMSMarker()
      marker.iconView = markerView
      marker.position = CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489)
      marker.rotation = 45
      marker.map = mapView
      
      mapView.delegate = self
   }
}

