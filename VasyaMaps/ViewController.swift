import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import SwiftEntryKit

class ViewController: UIViewController, PlacementOnLocation {
    static var shared: ViewController = ViewController()
    
    var mapView = AppDelegate.mapsView
    
    var pickerView = UIPickerView()
    var locationMager: CLLocationManager?
    
    override func viewDidLoad() {
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.465339, longitude: 35.076775, zoom: 15.0)
        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        
        self.mapView.camera = camera
        
        self.locationMager?.delegate = self
        self.locationMager?.requestWhenInUseAuthorization()
        //        self.locationMager?.desiredAccuracy = kCLLocationAccuracyBest
        
        self.mapView.delegate = self
        
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.markersUpdate(mapView: self.mapView)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        self.locationMager?.requestLocation()
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        //        self.mapView.settings.zoomGestures = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        self.mapView.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: 15, zoom: 0, bearing: 0, viewingAngle: 0)
        
        print("Location = \(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

extension ViewController: GMSMapViewDelegate, LocationProtocol, CustomALertProtocol {
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        rememberLocation(coordinate, self.pickerView, self.mapView, self)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var colorMarker = String()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataValues.entityLocation.rawValue)
        
        for i in AppDelegate.location {
            if marker.position.latitude == i.value(forKey: CoreDataValues.attributeLatitude.rawValue) as! CLLocationDegrees && marker.position.longitude == i.value(forKey: CoreDataValues.attributeLongtitude.rawValue) as! CLLocationDegrees {
                colorMarker = i.value(forKey: CoreDataValues.attributeColor.rawValue) as! String
                print(colorMarker)
            }
        }
        
        Color.shared.color = PinColor(rawValue: colorMarker)
        
        
        
                
        let markerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
                
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(markerLocation) { (placemarks, error) in
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                DispatchQueue.main.async {
                    
                    let city = placemark.locality ?? "unknown"
                    let address = placemark.name ?? "unknown"
                    let country = placemark.country ?? "unknown"
                    let markerTitle = marker.title ?? "unknown"
                    
                    self.showCustomAlert(markerTitle: markerTitle, country: country, city: city, address: address, location: self.setLocationValuesInCustomAlert(tapMarker: marker), marker: marker)
                }
            }
        }
        return true
    }
}

extension ViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return PinColor.Red.rawValue
        case 1:
            return PinColor.Violet.rawValue
        case 2:
            return PinColor.Blue.rawValue
        case 3:
            return PinColor.Black.rawValue
        case 4:
            return PinColor.Yellow.rawValue
        case 5:
            return PinColor.Green.rawValue
        default:
            return PinColor.Gray.rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            Color.shared.color = .Red
        case 1:
            Color.shared.color = .Violet
        case 2:
            Color.shared.color = .Blue
        case 3:
            Color.shared.color = .Black
        case 4:
            Color.shared.color = .Yellow
        case 5:
            Color.shared.color = .Green
        case 6:
            Color.shared.color = .Gray
        default:
            break
        }
    }
}
