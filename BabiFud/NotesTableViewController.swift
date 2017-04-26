

import UIKit
import CloudKit

final class NotesTableViewController: UITableViewController {

  // MARK: - Properties
  var notes: [CKRecord] = []

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Model.sharedInstance.fetchNotes { (notes: [CKRecord]?, error: NSError?) in
      guard error == nil else { return }
      
      self.notes = notes!
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension NotesTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
    let record: CKRecord = notes[(indexPath as NSIndexPath).row] 
    cell.notesLabel.text = record["Note"] as? String

    guard let establishmentRef = record["Establishment"] as? CKReference,
      let establishment = Model.sharedInstance.establishment(establishmentRef) else {
        cell.thumbImageView.image = nil
        cell.titleLabel.text = "???"
        return cell
    }

    cell.titleLabel.text = establishment.name
    establishment.loadCoverPhoto() { photo in
      DispatchQueue.main.async {
        cell.thumbImageView.image = photo
      }
    }

    return cell
  }
}
