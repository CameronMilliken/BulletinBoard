//
//  MessageListViewController.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/25/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, UITextFieldDelegate{

    private let messageController = MessageController()
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        return formatter
    }
    
    //   MARK: - Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageController.fetchAllMessage { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    
     //   MARK: - Action
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let text = messageTextField.text, !text.isEmpty else { return}
        messageController.postNewMessage(with: text) { (success) in
            if success {
               DispatchQueue.main.async {
                self.tableView.reloadData()
                self.messageTextField.text = ""
            }
        }
    }
}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageController.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let message = messageController.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text  = dateFormatter.string(from: message.timeStamp)
        
        return cell
    }
    
    
}
