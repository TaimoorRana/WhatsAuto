//
//  SearchTableViewController.swift
//  WhatsAuto
//
//  Created by Taimoor Rana on 2016-01-23.
//  Copyright © 2016 Taimoor Rana. All rights reserved.
//

import UIKit
import Parse

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBAction func SignoutClicked(sender: AnyObject) {
        PFUser.logOut()
        print("logout")
    }
	let appleProducts = [""]
	var filteredAppleResults = [String]()
	var resultSearchController = UISearchController()

	@IBAction func signOutClicked(sender: AnyObject) {
		PFUser.logOut()
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	
	@IBOutlet var testTable: UITableView!
	
    override func viewDidLoad() {
		super.viewDidLoad();
		resultSearchController = UISearchController(searchResultsController: nil)
		resultSearchController.searchResultsUpdater = self
		resultSearchController.dimsBackgroundDuringPresentation = false
		resultSearchController.searchBar.sizeToFit()
				
		tableView.tableHeaderView = resultSearchController.searchBar
		tableView.reloadData()

		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if resultSearchController.active {
			return filteredAppleResults.count
		}else{
			return appleProducts.count
		}
		
    }
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell;

		if ((cell.textLabel?.text)! != ""){
			let searchUser = PFQuery(className: "_User")
			searchUser.whereKey("licensePlate", equalTo: (cell.textLabel?.text)!)
			searchUser.getFirstObjectInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
				otherUser = object!["email"] as! String
			}
			
			resultSearchController.active = false
			performSegueWithIdentifier("GoToConversationVC", sender: self)
		}
	}

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell?

        // Configure the cell...
		if resultSearchController.active {
			cell!.textLabel?.text = filteredAppleResults[indexPath.row]
		}else{
			cell!.textLabel?.text = appleProducts[indexPath.row]
		}

        return cell!
    }
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		filteredAppleResults.removeAll(keepCapacity: false)
        let currentUser = PFUser.currentUser()
		self.testTable.reloadData()
		let resultsQuery = PFQuery(className: "_User")
		resultsQuery.whereKey("licensePlate", containsString: searchController.searchBar.text!)
		
		if searchController.searchBar.text != ""{
			resultsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
				if objects?.count > 0 {
					for object in objects!{
                        let plate = object["licensePlate"] as! String
                        if plate != currentUser!["licensePlate"] as! String{
                            self.filteredAppleResults.append(object["licensePlate"] as! String)
                        }
					}
				
				}
			
				self.testTable.reloadData()
			
			}
		}
		//let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
		//let array = (appleProducts as NSArray).filteredArrayUsingPredicate(searchPredicate)
		//filteredAppleResults = array as! [String]
		tableView.reloadData()
	}
	
	
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
