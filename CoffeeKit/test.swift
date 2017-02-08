//
//  test.swift
//  CoffeeKit
//
//  Created by Rikard Olsson on 2017-02-03.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//
/*
import UIKit

class BE {
    static func fetchUsers(_ callback: @escaping (_ users: [String]?, _ error: CoffeeError?) -> Void) {
        callback(["Rikard", "Olsson"], nil)
    }
}

class TestViewController : UIViewController {
    
    var EventHandler = MasterEventHandler<NSError>()
    var tableView: UITableView!
    var users: [String]!
    
    func setDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventHandler.loadMaster { (error) in
            if error == nil {
                // Do something knowing everything is done
            }
        }
        
        let fetchUsers = EventHandler.loadSlave(numberToFetch: "fetchUsers") { (error) in
            if error == nil {
                // Users is fetched
            }
        }
        
        BE.fetchUsers { (users, error) in
            if let users = users {
                self.users = users
            }
            
            fetchUsers.fire(error)
        }
    }
    
    func fetchViewData() {
        
    }
}

extension TestViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
 */
