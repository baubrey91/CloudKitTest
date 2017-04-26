

import UIKit

final class NotesViewController: UIViewController {

  // MARK: - Properties
  var establishment: Establishment!

  // MARK: - IBOutlet
  @IBOutlet var textView: UITextView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
  }
  
  func keyboardWillShow(_ note: Notification) {
    let userInfo: NSDictionary = (note as NSNotification).userInfo! as NSDictionary
    let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
    let keyboardFrame = keyboardFrameValue.cgRectValue as CGRect
    var contentInsets = textView.contentInset
    contentInsets.bottom = keyboardFrame.height
    
    textView.contentInset = contentInsets
    textView.scrollIndicatorInsets = contentInsets
  }
  
  func keyboardWillHide(_ note: Notification) {
    var contentInsets = textView.contentInset
    contentInsets.bottom = 0.0
    textView.contentInset = contentInsets
    textView.scrollIndicatorInsets = contentInsets
  }
}

// MARK: - IBActions
extension NotesViewController {

  @IBAction func save(_ sender: AnyObject) {
    let noteText = textView.text
    if let noteText = noteText {
      Model.sharedInstance.addNote(noteText, establishment: establishment) { [unowned self] error in
        
        guard error != nil else {
          let viewControllers = self.navigationController?.viewControllers
          let detailController = viewControllers![0] as! DetailViewController
          detailController.noteTextView.text = noteText
          _ = self.navigationController?.popViewController(animated: true)
          return
        }
        let alertController = UIAlertController(title: "Error saving note",
                                                message: error?.localizedDescription,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
      }
    
    }
  }
}
