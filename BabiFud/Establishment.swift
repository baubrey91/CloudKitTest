
import Foundation
import CloudKit
import MapKit

class Establishment: NSObject, MKAnnotation {

  // MARK: - Properties
  var record: CKRecord!
  var name: String!
  var location: CLLocation!
  weak var database: CKDatabase!
  var assetCount = 0

  var healthyChoice: Bool {
    guard let hasHealthyChoice = record["HealthyOption"] as? NSNumber else { return false }
    return hasHealthyChoice.boolValue
  }

  var kidsMenu: Bool {
    guard let hasKidsMenu = record["KidsMenu"] as? NSNumber else { return false }
    return hasKidsMenu.boolValue
  }

  // MARK: - Map Annotation Properties
  var coordinate: CLLocationCoordinate2D {
    return location.coordinate
  }

  var title: String? {
    return name
  }

  // MARK: - Initializers
  init(record: CKRecord, database: CKDatabase) {
    self.record = record
    self.database = database

    self.name = record["Name"] as? String
    self.location = record["Location"] as? CLLocation
  }

  func fetchRating(_ completion: @escaping (_ rating: Double, _ isUser: Bool) -> ()) {
    Model.sharedInstance.userInfo.userID() { [weak self] userRecord, error in
      self?.fetchRating(userRecord, completion: completion)
    }
  }
  
  func fetchRating(_ userRecord: CKRecordID!, completion: (_ rating: Double, _ isUser: Bool) -> ()) {
    // Capability not yet implemented.
    completion(0, false)
  }

  func fetchNote(_ completion: @escaping (_ note: String?) -> ()) {
    Model.sharedInstance.fetchNote(self) { note, error in
      completion(note)
    }
  }
  
  func fetchPhotos(_ completion: @escaping (_ assets: [CKRecord]?) -> ()) {
    let predicate = NSPredicate(format: "Establishment == %@", record)
    let query = CKQuery(recordType: "EstablishmentPhoto", predicate: predicate)

    // Intermediate Extension Point - with cursors
    database.perform(query, inZoneWith: nil) { [weak self] results, error in
      defer {
        completion(results)
      }

      guard error == nil,
        let results = results else {
          return
      }

      self?.assetCount = results.count
    }
  }
  
  func changingTable() -> ChangingTableLocation {
    let changingTable = record["ChangingTable"] as? NSNumber
    var val: UInt = 0
    guard let changingTableNum = changingTable else {
      return ChangingTableLocation(rawValue: val)
    }
    val = changingTableNum.uintValue
    return ChangingTableLocation(rawValue: val)
  }
  
  func seatingType() -> SeatingType {
    let seatingType = record["SeatingType"] as? NSNumber
    var val: UInt = 0
    guard let seatingTypeNum = seatingType else {
      return SeatingType(rawValue: val)
    }
    val = seatingTypeNum.uintValue
    return SeatingType(rawValue: val)
  }

  func loadCoverPhoto(completion:@escaping (_ photo: UIImage?) -> ()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).sync {
      var image: UIImage!
      
      defer {
        completion(image)
      }
      guard let asset = self.record["CoverPhoto"] as? CKAsset else {
        return
      }
      
      let imageData = Data
      
      do {
        imageData = try Data(contentsOf: <#T##URL#>)
      }
    }
  }
}
