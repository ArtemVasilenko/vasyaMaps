import Foundation
import CoreData
import GoogleMaps

protocol PlacementOnLocation: SetMarkerProtocol {
    func placementOnLocation (entity: [NSManagedObject], mapView: GMSMapView)
    func markersUpdate(mapView: GMSMapView)
    func markerChangeTitle(entity: NSManagedObject, name: String)
    func markerDelete(entity: NSManagedObject, marker: GMSMarker)
    func markerChangeColor(entity: NSManagedObject, color: String, marker: GMSMarker)
    func setColorInPicker(pinColor: PinColor) -> Int
}

extension PlacementOnLocation {
    
    func placementOnLocation (entity: [NSManagedObject], mapView: GMSMapView) {
        for value in entity {
            createAndSetMarker(entity: value, mapView: mapView)
        }
    }
    func markersUpdate(mapView: GMSMapView) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataValues.entityLocation.rawValue)
        
        do {
            AppDelegate.location = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        placementOnLocation(entity: AppDelegate.location, mapView: mapView)
        
        print("Markers is update!")
        print(AppDelegate.location)
    }
    func markerChangeTitle(entity: NSManagedObject, name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataValues.entityLocation.rawValue)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                if object == entity {
                    object.setValue(name, forKey: CoreDataValues.attributeName.rawValue)
                }
            }
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not delete object. \(error), \(error.userInfo)")
        }
        print(entity)
    }
    func markerChangeColor(entity: NSManagedObject, color: String, marker: GMSMarker) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataValues.entityLocation.rawValue)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                if object == entity {
                    object.setValue(color, forKey: CoreDataValues.attributeColor.rawValue)
                    marker.icon = GMSMarker.markerImage(with: UIColor.colorWith(name: color))
                }
            }
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not delete object. \(error), \(error.userInfo)")
        }
        print(entity)
    }
    func markerDelete(entity: NSManagedObject, marker: GMSMarker) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataValues.entityLocation.rawValue)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                if object == entity {
                    managedContext.delete(object)
                }
            }
            
            try managedContext.save()
            marker.map = nil
            
        } catch let error as NSError {
            print("Could not delete object. \(error), \(error.userInfo)")
        }
    }
    func setColorInPicker(pinColor: PinColor) -> Int {
        switch pinColor {
        case .Red: return 0
        case .Violet: return 1
        case .Blue: return 2
        case .Black: return 3
        case .Yellow: return 4
        case .Green: return 5
        case .Gray: return 6
    }
        
    }
}
