

import Foundation
import UIKit
import CloudKit
import CoreLocation

func upload(_ db: CKDatabase,
            imageName: String,
            placeName: String,
            latitude:  CLLocationDegrees,
            longitude: CLLocationDegrees,
            changingTable: ChangingTableLocation,
            seatType:  SeatingType,
            healthy: Bool,
            kidsMenu: Bool,
            ratings: [UInt]) {
  
  let imURL = Bundle.main.url(forResource: imageName, withExtension: "jpeg")
  let coverPhoto = CKAsset(fileURL: imURL!)
  let location = CLLocation(latitude: latitude, longitude: longitude)
  
  let establishment = CKRecord(recordType: "Establishment")
  establishment.setObject(coverPhoto, forKey: "CoverPhoto")
  establishment.setObject(placeName as CKRecordValue?, forKey: "Name")
  establishment.setObject(location, forKey: "Location")
  establishment.setObject(changingTable.toRaw() as CKRecordValue?, forKey: "ChangingTable")
  establishment.setObject(changingTable.toRaw() as CKRecordValue?, forKey: "SeatingType")
  establishment.setObject(healthy as CKRecordValue?, forKey: "HealthyOption")
  establishment.setObject(kidsMenu as CKRecordValue?, forKey: "KidsMenu")
  
  
  db.save(establishment, completionHandler: { record, error in
    
    guard error == nil else {
      print("error setting up record \(error)")
      return
    }
    
    print("saved: \(record)")
    
    for rating in ratings {
      
      let ratingRecord = CKRecord(recordType: "Rating")
      ratingRecord.setObject(rating as CKRecordValue?, forKey: "Rating")
      
      let ref = CKReference(record: record!, action: CKReferenceAction.deleteSelf)
      ratingRecord.setObject(ref, forKey: "Establishment")
      
      db.save(ratingRecord, completionHandler: { record, error in
        guard error == nil else {
          print("error setting up record \(error)")
          return
        }
      }) 
    }
    
  }) 
}

func doWorkaround() {
  
  let container = CKContainer.default()
  let db = container.publicCloudDatabase;
  
  // Apple Campus location = 37.33182, -122.03118
  
  upload(db, imageName: "pizza",
         placeName: "Ceasar's Pizza Palace",
         latitude: 37.332, longitude: -122.03,
         changingTable: ChangingTableLocation.Womens,
         seatType: SeatingType.HighChair | SeatingType.Booster,
         healthy: false,
         kidsMenu: true,
         ratings: [0, 1, 2])
  
  upload(db, imageName: "chinese",
         placeName: "King Wok",
         latitude: 37.1, longitude: -122.1,
         changingTable: ChangingTableLocation.None,
         seatType: SeatingType.HighChair,
         healthy: true,
         kidsMenu: false,
         ratings: [])
  
  upload(db, imageName: "steak",
         placeName: "The Back Deck",
         latitude: 37.4, longitude: -122.03,
         changingTable: ChangingTableLocation.Womens | ChangingTableLocation.Mens,
         seatType: SeatingType.HighChair | SeatingType.Booster,
         healthy: true,
         kidsMenu: true,
         ratings: [5, 5, 4])
}
