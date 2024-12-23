import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        title = K.appName
        
        loadMessages()
        
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was some error fetching messages: \(e)")
            } else {
                if let querySnapshot = querySnapshot?.documents {
                    for i in querySnapshot {
                        let data = i.data()
                        if let sender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: body)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressedButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let message = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: message,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print ("There was an issue adding document to database \(e)")
                } else {
                    print("All data has been saved successfully .")
                }
            }
            
        }
        messageTextfield.text = ""
    }
}



extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actualMessage = messages[indexPath.row]
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        myCell.label?.text = actualMessage.body
        
        if actualMessage.sender == Auth.auth().currentUser?.email {
            myCell.leftImageView.isHidden = true
            myCell.rightImageView.isHidden = false
            myCell.label.textColor = UIColor(named: K.BrandColors.purple)
            myCell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        } else {
            myCell.leftImageView.isHidden = false
            myCell.rightImageView.isHidden = true
            myCell.label.textColor = UIColor(named: K.BrandColors.purple)
            myCell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
        }
        
        return myCell
    }
    
    
}
