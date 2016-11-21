//
//  MyPlayersTableViewController.swift
//  NBA Team Selection App
//
//  Created by New User on 11/15/16.
//  Copyright © 2016 Will Garner. All rights reserved.
//

import UIKit
import CloudKit

class Player {
  
  var name : String!
  var pointsPerGame: Int?
  var record : CKRecord!
  
  
  
}

class MyPlayersTableViewController: UITableViewController {
  
  
  var container : CKContainer!
  var publicDB :CKDatabase!
  
  
  
  
  var team :Team!
  var players :[Player]!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.title = self.team.name
    
    self.container = CKContainer.default()
    self.publicDB = self.container.publicCloudDatabase
    
    self.players = [Player]()
    
    populatePlayers()
    
  }
  
  func populatePlayers() {
    
    let query = CKQuery(recordType: "Players", predicate: NSPredicate(format: "Team == %@", team.record))
    
    self.publicDB.perform(query, inZoneWith: nil)
    {(records : [CKRecord]?, error : Error?) in
      
      for record in records! {
        
        let player = Player()
        player.record = record
        player.name = record.value(forKey: "Name") as! String
        player.pointsPerGame = record.value(forKey: "PointsPerGame") as? Int
        self.players.append(player)
      }
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let indexPath = self.tableView.indexPathForSelectedRow
    let player = self.players[(indexPath?.row)!]
    
    //    let playersTradeVC = segue.destination as!
    //      PlayersTradeVC.player = player
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.players.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
    
    let player = self.players[indexPath.row]
    
    cell.textLabel?.text = player.name
    
    return cell
  }
  
  
}
