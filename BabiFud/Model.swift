import Foundation
import CloudKit
import CoreLocation

// Specify the protocol to be used by view controllers to handle notifications.
protocol ModelDelegate {
  func errorUpdating(_ error: NSError)
  func modelUpdated()
}

class Model {

  // MARK: - Properties
  let EstablishmentType = "Establishment"
  let NoteType = "Note"
  static let sharedInstance = Model()
  var delegate: ModelDelegate?
  var items: [Establishment] = []
  let userInfo: UserInfo
  
  // Define databases.

  // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
  let container: CKContainer
  let publicDB: CKDatabase
  let privateDB: CKDatabase

  // MARK: - Initializers
  init() {
    container = CKContainer.default()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
    
    userInfo = UserInfo(container: container)
  }
  
  @objc func refresh() {
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Establishment", predicate: predicate)
    
    publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in

      guard error == nil else {
        DispatchQueue.main.async {
          self.delegate?.errorUpdating(error! as NSError)
          print("Cloud Query Error - Refresh: \(error)")
        }
        return
      }
      
      self.items.removeAll(keepingCapacity: true)
      
      for record in results! {
        let establishment = Establishment(record: record, database: self.publicDB)
        self.items.append(establishment)
      }
      
      DispatchQueue.main.async {
        self.delegate?.modelUpdated()
      }
    }
  }

  func establishment(_ ref: CKReference) -> Establishment! {
    let matching = items.filter { $0.record.recordID == ref.recordID }
    return matching.first
  }

  func fetchEstablishments(_ location:CLLocation, radiusInMeters:CLLocationDistance) {
    // 1
    let radiusInKilometers = radiusInMeters / 1000.0
    // 2
    
    let locationPredicate = NSPredicate(value: true)

    //let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location", location, radiusInKilometers)
    // 3
    let query = CKQuery(recordType: EstablishmentType, predicate: locationPredicate)
    // 4
    publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
      if let error = error {
        DispatchQueue.main.async {
          self.delegate?.errorUpdating(error as NSError)
          print("Cloud Query Error - Fetch Establishments: \(error)")
        }
        return
      }
      print(results?.count)
      self.items.removeAll(keepingCapacity: true)
      results?.forEach({ (record: CKRecord) in
        self.items.append(Establishment(record: record,
                                        database: self.publicDB))
      })
      
      DispatchQueue.main.async {
        self.delegate?.modelUpdated()
      }
    }
  }
  
  func fetchEstablishments(_ location: CLLocation,
                           radiusInMeters: CLLocationDistance,
                           completion: @escaping (_ results: [Establishment]?, _ error: NSError?) -> ()) {
    
    let radiusInKilometers = radiusInMeters / 1000.0
    
    // Apple Campus location = 37.33182, -122.03118
    let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
    let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location", location, radiusInKilometers)
    
    let query = CKQuery(recordType: EstablishmentType,
                        predicate:  locationPredicate)

    publicDB.perform(query, inZoneWith: nil) { results, error in
      var res: [Establishment] = []

      defer {
        DispatchQueue.main.async {
          completion(res, error as NSError?)
        }
      }
      
      guard let records = results else { return }
      
      for record in records {
        let establishment = Establishment(record: record , database:self.publicDB)
        res.append(establishment)
      }
    }
  }

  // MARK: - Notes
  func fetchNotes(_ completion: @escaping (_ notes: [CKRecord]?, _ error: NSError?) -> () ) {
    
    let query = CKQuery(recordType: NoteType, predicate: NSPredicate(value: true))

    privateDB.perform(query, inZoneWith: nil) { results, error in
      completion(results, error as NSError?)
    }
  }

  func fetchNote(_ establishment: Establishment, completion:(_ note: String?, _ error: NSError?) ->()) {
    // Capability not yet implemented.
    completion(nil, nil)
  }

  func addNote(_ note: String, establishment: Establishment!, completion: (_ error: NSError?)->()) {
    // Capability not yet implemented.
    completion(nil)
  }
}
