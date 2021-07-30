//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var messages:[Message] = [Message(sender: "1@aka.com", body: "123456"), Message(sender: "1@aka.com", body: "Hello!"),Message(sender: "1@aka.com", body: "Whats Up?")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //--> the title on the navigation app bar
        title = K.appName
        navigationItem.hidesBackButton = true
        
        //--> registering the custom chat screen message cell
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
        //--> this is to clear out the dummy messages that we have so that we can make use of
        // messages stored in our firebase database
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.messages = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    //the downcast is because fire base returns a dictionary with a type of any and its an optional,
                    //so we have to downcast it to the type we want and then unwrap the optional
                    if let messageSender = data[K.FStore.senderField] as? String ,  let messageBody = data[K.FStore.bodyField] as? String {
                        
                        let newMessage = Message(sender: messageSender, body: messageBody)
                        self.messages.append(newMessage)
                        
                        //note: anytime you are perfomring an async wait operation, or an operation that will  manipute the UI when it has finished, use the dispatch queue
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            //scroll to the bottom everytime a new message is added
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //meaning if the messageTextfield.text || Auth.auth().currentUser?.email are not nil, save
        //them inside the message body
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName)
                .addDocument(data:
                                [K.FStore.senderField: messageSender,
                                 K.FStore.bodyField: messageBody,
                                 K.FStore.dateField: Date().timeIntervalSince1970 //this was used here to order the responses, so that the latest addition to the database shows up as the last message.(AS INDICATED IN THE ORDER BY in loadmessages())
                                ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore \(e)")
                }else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                   
                    print("Successfully saved data")
                }
            }
        }
        
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            //--> removes all the controllers on the stack and sends you to the first stack
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    //--> tells the table view how many cells it needs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //--> THIS IS A LOOP FUNCTION
    //--> this method will be called everytime the table rows function
    //--> above is called. (i.e called for every created row)
    //--> this what acttually creates the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        
        //--> link up the selected cell to this function
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            as! MessageCell //--> NOTE: this was added after. it just forcefully downcasts the normal table reusable cell to our own custom created cell
        //--> forced down casting is basically changing the type of a superclass to one of its subclass
        //--> as actually raises the casting (i.e from subclass to superclass)
        
        
        
        
        //--> get the current index of the loop
        //    let index = indexPath.row
        //--> assign the message from the message object above to the
        //--> textLabel
        //--> cell.textLabel?.text = "\(messages[index].body)"
        
        cell.label?.text = "\(message.body)"
        
        
        //This is a message from the current user. If the message is being sent by the current signed in user,
        // then the message cell will look different
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            //--> in order to use custom colors, we must make use of the named property in UIColor
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        //This is a message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            //--> in order to use custom colors, we must make use of the named property in UIColor
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
       
        return cell
    }
}


//--> this method is not in use at the moment in the app
//--> to see it work, select the cell, change the selection property
//--> from none to default
extension ChatViewController: UITableViewDelegate {
    //--> when a particular row in the table view is selected, this method
    //--> will be triggered
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
