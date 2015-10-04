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
import SwiftyJSON

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let dataModel = DataModel()
    var auth: Bool = false
    
    var currentUser:User!
    
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
        self.tableView.allowsSelection = false

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func authenticated() -> Bool {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            if let u =  User.getUserWithUserID(FBSDKAccessToken.currentAccessToken().userID) {
                self.currentUser = u
                loadPosts()
            }
            return true
        } else {
            return false
        }
    }
    
    func loadPosts() {
        let provider = MoyaProvider<FirstlyAPI>()
        let tokenString = FBSDKAccessToken.currentAccessToken().tokenString
        provider.request(.Feed(tokenString), completion: { (data, statusCode, response, error) -> () in
            if let data = data where statusCode == 200 {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let json = JSON(data:data)
                    let dm = DataModel()
                    for (_, subJSON):(String, JSON) in json {
                        let userID = subJSON["_user"]["facebookId"].string!
                        let username = subJSON["_user"]["facebookName"].string!
                        var user = User(username: username, userID: userID)
                            dm.realm?.write{
                                dm.realm?.add(user, update:true)
                            }
                        let dateString = subJSON["dateCreated"].string!
                        let postText = subJSON["text"].string!
                        let postID = subJSON["_id"].string!
                        
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let posix = NSLocale(localeIdentifier: "en_US_POSIX")
                        formatter.locale = posix
                        let date = formatter.dateFromString(dateString)
                        
                        let post = Post(postText: postText, poster: user, postDate: date!, postID: postID, imageData: nil)
                        dm.realm?.write {
                            dm.realm?.add(post, update: true)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                })
            }
        })

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
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    })
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
        
        let poster = object?.poster
        let image = poster?.image?.image
        if let image = image {
            cell.profilePictureView.image = image
        }
        
        
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



