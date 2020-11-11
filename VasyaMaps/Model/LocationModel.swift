import Foundation
import GoogleMaps
import UIKit
import CoreData

protocol LocationProtocol: UIPickerViewDelegate, UIPickerViewDataSource {
    func rememberLocation(_ coordinate: CLLocationCoordinate2D, _ colorPickerView: UIPickerView, _ mapView: GMSMapView, _ vc: UIViewController)
}

extension LocationProtocol {
    func rememberLocation(_ coordinate: CLLocationCoordinate2D, _ colorPickerView: UIPickerView, _ mapView: GMSMapView, _ vc: UIViewController) {
                
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
//        blurVisualEffectView.frame = vc.view.bounds
        
        let alert = UIAlertController(title: SaveLocationAlert.shared.title, message: SaveLocationAlert.shared.alertMessage, preferredStyle: .alert)
            
        
        
        alert.addTextField { (textField) in
            textField.placeholder = SaveLocationAlert.shared.enterName
        }
        
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorPickerView.frame = CGRect(x: 30, y: 70, width: alert.view.frame.width / 2, height: 140)
        alert.view.addSubview(colorPickerView)
        
        
        
        let okAction = UIAlertAction(title: SaveLocationAlert.shared.okAction, style: .default) { (action) in
            
            guard alert.textFields![0].text != "" else { return }
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext) ?? NSEntityDescription()
            
            let location = NSManagedObject(entity: entity, insertInto: managedContext)
            
            location.setValue(alert.textFields![0].text, forKey: "name")
            location.setValue(Float(coordinate.longitude), forKey: "longtide")
            location.setValue(Float(coordinate.latitude), forKey: "latitude")
            location.setValue(Color.shared.color?.descriptionImage, forKey: "color")
            
            
            do {
                try managedContext.save()
                AppDelegate.location.append(location)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
            
                
//                locations.append(newLocation)
//                self.insertLocation(newLocation)
//                self.createAndSetMarker(newLocation, mapView)
            
        }
        
        let cancelAction = UIAlertAction(title: SaveLocationAlert.shared.cancelAction, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
//        blurVisualEffectView.removeFromSuperview()
        }
    
    
}
