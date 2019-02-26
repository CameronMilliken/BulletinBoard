//
//  MessageSearchViewController.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/26/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class MessageSearchViewController: UIViewController, UITableViewDataSource {

   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let userController = UserController()
    let messageController = MessageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        userController.requestDiscoverabiltyAuthentication { (success) in
            //Handle
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageController.filteredMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let message = messageController.filteredMessages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = "\(message.timeStamp)"
        return cell
    }
    
}

extension MessageSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let email = searchBar.text,
        !email.isEmpty
            else {return}
        
        messageController.fetchMessagesForUser(email: email) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                //handle error
            }
        }
    }
}


