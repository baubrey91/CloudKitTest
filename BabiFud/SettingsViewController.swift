

import UIKit
import CloudKit

final class SettingsViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Settings"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateLogin()
  }

  func updateLogin() {
    let indexPath = IndexPath(row: 0, section: 0)
    guard let cell = tableView.cellForRow(at: indexPath) else { return }

    Model.sharedInstance.userInfo.loggedInToICloud { accountStatus, error in
      var text  = "Could not determine iCloud account status."

      defer {
        DispatchQueue.main.async {
          cell.textLabel?.text = text
          self.tableView.reloadData()
        }
      }

      guard case(.available) = accountStatus else { return }

      text = "Logged in to iCloud"
      Model.sharedInstance.userInfo.userInfo() { userInfo, error in
        guard let userInfo = userInfo,
          let displayContact = userInfo.displayContact else {
            return
        }

        DispatchQueue.main.async {
          let nameText = "Logged in as \(displayContact.givenName) \(displayContact.familyName)"
          cell.textLabel?.text = nameText
        }
      }
    }
  }
}
