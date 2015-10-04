//
//  NewExperienceViewController.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import UIKit
import Moya
import FBSDKCoreKit

typealias NewExperienceCallback = (Bool) -> ()
typealias NewExperienceCompletionHandler = (Post, NewExperienceCallback) -> ()

class NewExperienceViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var currentUser: User!
    var completionHandler: NewExperienceCompletionHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
//        if self.textField.text?.characters.count > 0 {
//            self.textField.resignFirstResponder()
//            
//            let facebookToken = FBSDKAccessToken.currentAccessToken().tokenString
//            
//            let provider = MoyaProvider<FirstlyAPI>()
//            provider.request(FirstlyAPI.PostExperience(facebookToken,textField.text!), completion: { (data, statusCode, response, error) -> () in
//                let post = Post(postText: self.textField.text!, poster: , postDate: NSDate(), postID: NSUUID().UUIDString, imageData: nil)
//                let callback: NewExperienceCallback = {(success: Bool) in
//                    if success {
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    }
//                }
//                completionHandler(post, callback)
//            })
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
