
import GoogleMaps
import Network
import UIKit

class ViewController: UIViewController {
   @IBOutlet weak var mapView: GMSMapView!
   @IBOutlet weak var deviceAddressLabel: UILabel!
   
   var listener: NWListener?
   let udpPort: NWEndpoint.Port = 49003
   var connection: NWConnection?
   
   let marker = GMSMarker()
   
   var tracking = true  /// Tracks whether GPS tacking is enabled
   var isMapIdle = true /// Tracks whether a natural gesture (such as a pan or tilt) on the GMSMapView is in progress. We need it to pause GPS tracking while a user performing the gesture.
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      if let deviceAddress = getIPAddress() {
         deviceAddressLabel.text = "\(deviceAddress):\(udpPort)"
      }
      
      // Create a default camera and a marker in the center of the map
      mapView.camera = GMSCameraPosition.camera(withLatitude: Belgrade.lat, longitude: Belgrade.lng, zoom: 13.0)
      
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
   
   func updateDisplayWithDataset(_ index: Int, values: [Float32]) {
      switch index {
      case 19: // 19 : [85.02289, -4.919937, -999.0, -999.0, -999.0, -999.0, -999.0, -999.0]
         let degrees = CLLocationDegrees(values[0])
         marker.rotation = degrees - 90 // -90 since airplane SF Icon is initialy rotated by 45 degrees
         
      case 20: // 20 : [44.825912, 20.293478, 339.2952, 0.254495, 0.0, 339.295, 44.5, 20.0]
         let lat = CLLocationDegrees(values[0])
         let lng = CLLocationDegrees(values[1])
         marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
         
         if tracking && isMapIdle {
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
      isMapIdle = false
      // Note: If the gesture argument is set to true, this is due to a user performing a natural gesture on the GMSMapView, such as a pan or tilt. Otherwise, false indicates that this is part of a programmatic change.
   }
   
   func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      isMapIdle = true
   }
}

// MARK: - Default center for the map

fileprivate struct Belgrade {
   static let lat = 44.7866
   static let lng = 20.4489
}
