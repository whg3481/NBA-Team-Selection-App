//
//  TeamsViewController.swift
//  NBA Team Selection App
//
//  Created by New User on 11/13/16.
//  Copyright © 2016 Will Garner. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class TeamsViewController: UIViewController {
  
  @IBOutlet weak var teamNameTextField: UITextField!
  
  var container: CKContainer!
  var publicDB: CKDatabase!

    override func viewDidLoad() {
        super.viewDidLoad()

      self.container = CKContainer.default()
      self.publicDB = self.container.publicCloudDatabase
  
  }
  
  @IBAction func searchButtonPressed(_ sender: AnyObject){
    
    let teamName = self.teamNameTextField.text
    
    let teamSearchQuery = CKQuery(recordType: "Teams", predicate: NSPredicate(format: "Name == %@", teamName!))
    
    self.publicDB.perform(teamSearchQuery, inZoneWith: nil)  { (records: [CKRecord]?, error :Error?) in
      
      let teamRecord = records?.first
      
      let playersQuery = CKQuery(recordType: "player", predicate: NSPredicate(format: "Team == %@", teamRecord!))
      
      self.publicDB.perform(playersQuery, inZoneWith: nil, completionHandler: {(records :[CKRecord]?, error : Error?) in
        
        print(records)
        
  })
      
    }
    
  }

  
}
