
import GoogleMaps
import UIKit

extension ViewController {
   @IBAction func handleGPSTracking(_ sender: UISwitch) {
      tracking = sender.isOn
   }
   
   @IBAction func handleListening(_ sender: UIButton) {
      if let _ = listener {
         stopListening()
      } else {
         startListening()
      }
   }
   
   @IBAction func handleFocus(_ sender: UIButton) {
      let cameraUpdate = GMSCameraUpdate.setTarget(marker.position)
      mapView.animate(with: cameraUpdate)
   }
}
