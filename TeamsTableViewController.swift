//
//  TeamsTableViewController.swift
//  NBA Team Selection App
//
//  Created by New User on 11/10/16.
//  Copyright © 2016 Will Garner. All rights reserved.
//

import UIKit
import CloudKit



class TeamsTableViewController: UITableViewController {
  
  var teams : [Team]!
  
  var container : CKContainer!
  var publicDB : CKDatabase!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.teams = [Team]()
      
      self.container = CKContainer.default()
      self.publicDB = self.container.publicCloudDatabase
      
      populateTeams()
      
    }

  func populateTeams(){
    
    let query = CKQuery(recordType: "Teams", predicate: NSPredicate(value: true))
    
    self.publicDB.perform(query, inZoneWith: nil) { (records: [CKRecord]?,error:Error?) in
      
      for record in records! {
        
        let team = Team()
        
        team.record = record
        
        team.name = record.value(forKey: "Name") as! String
        
        self.teams.append(team)
      }
      
//      func loadCoverPhoto(completion:@escaping (_ photo: UIImage?) -> ()) {
//        // 1
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
//          var image: UIImage!
//          defer {
//            completion(image)
//          }
//          // 2
//          guard let asset = self.teams["CoverPhoto"] as? CKAsset else {
//            return
//          }
//          
//          let imageData: Data
//          do {
//            imageData = try Data(contentsOf: asset.fileURL)
//          } catch {
//            return
//          }
//          image = UIImage(data: imageData)
//        }
//      }
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
      
      print(records)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let indexPath = self.tableView.indexPathForSelectedRow
    let team = self.teams[(indexPath?.row)!]
    
    let playersTVC = segue.destination as! MyPlayersTableViewController
    
    playersTVC.team = team
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.teams.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let team = self.teams[indexPath.row]
    
    cell.textLabel?.text = team.name
    cell.textLabel?.font = UIFont(name:"Avenir", size:22)
    
    return cell
  }
  

}
