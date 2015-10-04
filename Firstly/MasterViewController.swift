//
//  MasterViewController.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKCoreKit
import Moya

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let dataModel = DataModel()
    var auth: Bool = false
    
    var currentUser = User(username: "mike", userID: "12345")
    
    var objects : Results<Post>? {
        if let realm = self.dataModel.realm {
            return realm.objects(Post).sorted("postDate", ascending: false)
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 60.0

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func authenticated() -> Bool {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            if let u =  User.getUserWithUserID(FBSDKAccessToken.currentAccessToken().userID) {
                self.currentUser = u
                let provider = MoyaProvider<FirstlyAPI>()
                let tokenString = FBSDKAccessToken.currentAccessToken().tokenString
                provider.request(.Feed(tokenString), completion: { (data, statusCode, response, error) -> () in
                    print(data)
                })
            }
            return true
        } else {
            return false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!authenticated()) {
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }

    func insertNewObject(sender: AnyObject) {
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects?[indexPath.row].postText
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "NewExperienceSegue" {
            let controller = segue.destinationViewController as! NewExperienceViewController
            controller.currentUser = currentUser
            controller.completionHandler = {(post: Post, completion: NewExperienceCallback) in
                if let realm = self.dataModel.realm {
                    realm.write{ () -> Void in
                        realm.add(post)
                    }
                    if let count = self.objects?.count {
                        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    completion(true)
                }
            }
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objects?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! PostListTableViewCell

        let object = objects?[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        cell.usernameLabel.text = object?.poster?.username
        cell.timestampLabel.text = object?.formattedDate()
        cell.postTextLabel.text = object?.postText
        
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.dataModel.realm?.delete((objects?[indexPath.row])!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}



