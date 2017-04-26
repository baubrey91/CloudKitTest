

import UIKit
import UIWidgets

class NotesCell: UITableViewCell {
  
  @IBOutlet var thumbImageView: UIImageView! {
    didSet {
      thumbImageView.clipsToBounds = true
      thumbImageView.layer.cornerRadius = 6
    }
  }
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var notesLabel: UILabel!  
}

