// https://developers.google.com/maps/documentation/ios-sdk/start#install-manually
// https://developers.google.com/maps/billing/gmp-billing?hl=en_US#maps-product
// https://console.cloud.google.com/google/maps-apis/metrics?project=xmap-298021&folder=&organizationId=&supportedpurview=project
import GoogleMaps
import Network
import UIKit

class ViewController: UIViewController {
   @IBOutlet weak var mapView: GMSMapView!
   
   var listener: NWListener?
   var connection: NWConnection?
   
   let marker = GMSMarker()
   
   var tracking = true
   var isIdle = true
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      mapView.camera = GMSCameraPosition.camera(withLatitude: Belgrade.lat, longitude: Belgrade.lng, zoom: 13.0)
      
      // Creates a marker in the center of the map.
      
      let airplane = UIImage(systemName: "airplane")
      let markerView = UIImageView(image: airplane)
      markerView.frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
      markerView.tintColor = .red
      
      marker.iconView = markerView
      marker.position = CLLocationCoordinate2D(latitude: Belgrade.lat, longitude: Belgrade.lng)
      marker.rotation = 45
      marker.map = mapView
      
      mapView.delegate = self
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      startListening()
   }
   
   func didReceiveUpdateForDataset(_ index: Int, values: [Float32]) {
      switch index {
      case 19: // 19 : [85.02289, -4.919937, -999.0, -999.0, -999.0, -999.0, -999.0, -999.0]
         let degrees = CLLocationDegrees(values[0])
         marker.rotation = degrees - 90 // -90 since airplane SF Icon is initialy rotated by 45 degrees
         
      case 20: // 20 : [44.825912, 20.293478, 339.2952, 0.254495, 0.0, 339.295, 44.5, 20.0]
         let lat = CLLocationDegrees(values[0])
         let lng = CLLocationDegrees(values[1])
         marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
         
         if tracking && isIdle {
            let cameraUpdate = GMSCameraUpdate.setTarget(marker.position)
            mapView.animate(with: cameraUpdate)
         }
      default:
         print("Not implemented")
      }
   }
}

extension ViewController: GMSMapViewDelegate {
   func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      isIdle = false
   }
   
   func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      isIdle = true
   }
}

// MARK: -

fileprivate struct Belgrade {
   static let lat = 44.7866
   static let lng = 20.4489
}
