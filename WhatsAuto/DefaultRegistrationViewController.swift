//
//  DefaultRegistrationViewController.swift
//  WhatsAuto
//
//  Created by Taimoor Rana on 2016-01-23.
//  Copyright © 2016 Taimoor Rana. All rights reserved.
//

import UIKit
import Parse

class DefaultRegistrationViewController: UIViewController {
	
	@IBOutlet weak var emailTF: UITextField!
	
	@IBOutlet weak var licensePlateTF: UITextField!

	@IBOutlet weak var phoneTF: UITextField!
	
	@IBOutlet weak var passwordTF: UITextField!
	
	@IBOutlet weak var ConfirmPasswordTF: UITextField!
	
	@IBOutlet weak var carImage: UIImageView!
	
	@IBAction func RegisterClicked(sender: AnyObject) {
		let user = PFUser()
		user.email = emailTF.text!
		user.username = emailTF.text!
		user.password = passwordTF.text!
		user["phone"] = ""
		user["licensePlate"] = licensePlateTF.text!
		user["image"] = "";
		
		user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
			if error == nil{
				print("Signed up")
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("user", forKey: "channels")
                currentInstallation["user"] = self.emailTF.text!
                currentInstallation.saveInBackground()
			}else{
				print(error)
			}
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
	}

}
