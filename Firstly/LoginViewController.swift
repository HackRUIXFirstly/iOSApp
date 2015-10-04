//
//  LoginViewController.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import UIKit
import Accounts
import FBSDKLoginKit
import Moya

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        self.facebookLoginButton.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print(error)
            return;
        }
        let accessToken = FBSDKAccessToken.currentAccessToken()
        if let accessToken = accessToken {
            let provider = MoyaProvider<FirstlyAPI>()
            provider.request(FirstlyAPI.FacebookLogin(accessToken.tokenString)) { (data, statusCode, response, error) -> () in  
                if statusCode == 200 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
        //TODO: upload FB token
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
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
