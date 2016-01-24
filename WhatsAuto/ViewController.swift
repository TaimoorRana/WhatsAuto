//
//  ViewController.swift
//  WhatsAuto
//
//  Created by Taimoor Rana on 2016-01-23.
//  Copyright © 2016 Taimoor Rana. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ViewController: UIViewController {

	@IBOutlet weak var emailOrPlateNumberTF: UITextField!
	
	@IBOutlet weak var passwordTF: UITextField!
	
	@IBOutlet weak var registerButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		registerButton.layer.cornerRadius = 3
        
        if(PFUser.currentUser() != nil){
            PFUser.logOut()
        }
        
        
	}
	
	@IBAction func FBLoginClicked(sender: AnyObject) {
		PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email", "user_about_me"]) {
			(user: PFUser?, error: NSError?) -> Void in
			if let user = user {
				if user.isNew {
					print("User signed up and logged in through Facebook!")
				} else {
					print("User logged in through Facebook!")
				}
				dispatch_async(dispatch_get_main_queue()){
					
					self.performSegueWithIdentifier("LoginToMain", sender: self)
					
				}
				
			} else {
				print("Uh oh. The user cancelled the Facebook login.")
			}
		}
	}
	
	@IBAction func SignInClicked(sender: AnyObject) {
    PFUser.logInWithUsernameInBackground(emailOrPlateNumberTF.text!, password: passwordTF.text!) { (user:PFUser?, error:NSError?) -> Void in
			if user != nil {
				dispatch_async(dispatch_get_main_queue()){
					
					self.performSegueWithIdentifier("LoginToMain", sender: self)
					
				}
			}
		}
        
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

}

