//
//  ConversationViewController.swift
//  WhatsAuto
//
//  Created by Taimoor Rana on 2016-01-23.
//  Copyright © 2016 Taimoor Rana. All rights reserved.
//

import UIKit
import Parse

var username = PFUser.currentUser()!.email!
var otherUser = ""
class ConversationViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
	
	@IBOutlet weak var messageScrollView: UIScrollView!
	
	@IBOutlet weak var frameMessageView: UIView!
	
	@IBOutlet weak var messageTextView: UITextView!
		
	@IBOutlet weak var line: UILabel!
	
	@IBOutlet weak var sendButton: UIButton!
	
		
		var messageX:CGFloat = 37.0
		
		var messageY:CGFloat = 26.0
		
		var messageArray = [String]()
		var senderArray = [String]()
		
		var scrollViewOriginalY:CGFloat = 0
		var frameMessageOriginalY:CGFloat = 0
		
		var frameX:CGFloat = 32
		var frameY:CGFloat = 21
		
		
		
		func refreshResults(){
			let width = view.frame.size.width
			let height = view.frame.size.height
			
			messageX = 37.0
			messageY = 26.0
			
			frameX = 32
			frameY = 21
			
			messageArray.removeAll()
			senderArray.removeAll()
			
			let innerP1 = NSPredicate(format: "sender = %@ AND receiver = %@", username, otherUser )
			let innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)
			
			let innerP2 = NSPredicate(format: "sender = %@ and receiver = %@", otherUser,username)
			let innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)
			
			let query = PFQuery.orQueryWithSubqueries([innerQ1,innerQ2])
			
			query.addAscendingOrder("createdAt")
			query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
				if error == nil {
					for object in objects!{
						self.senderArray.append(object.objectForKey("sender") as! String)
						self.messageArray.append(object.objectForKey("message") as! String)
					}
					
					for var i = 0; i < self.senderArray.count ; i++ {
						
						if self.senderArray[i] == username{
							
							let messageLabel:UILabel = UILabel()
							messageLabel.frame = CGRectMake(0, 0, self.messageScrollView.frame.size.width - 94, CGFloat.max)
							messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
							messageLabel.numberOfLines = 0
							messageLabel.text = self.messageArray[i]
							messageLabel.sizeToFit()
							messageLabel.layer.zPosition = 20
							messageLabel.frame.origin.x = (self.messageScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width
							
							messageLabel.frame.origin.y = self.messageY
							self.messageScrollView.addSubview(messageLabel)
							self.messageY += messageLabel.frame.size.height + 30
							let frameLabel:UILabel = UILabel()
							
							frameLabel.frame.size = CGSizeMake(messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
							frameLabel.frame.origin.x = self.messageScrollView.frame.size.width - self.frameX - frameLabel.frame.size.width
							frameLabel.frame.origin.y = self.frameY
							frameLabel.backgroundColor = UIColor.init(colorLiteralRed: 0.36, green: 0.58, blue: 0.66, alpha: 0.6)
							frameLabel.layer.masksToBounds = true
							frameLabel.layer.cornerRadius = 10
							self.messageScrollView.addSubview(frameLabel)
							self.frameY += frameLabel.frame.size.height + 20
							
							self.messageScrollView.contentSize = CGSizeMake(width, self.messageY)
							
						}else{
							
							let messageLabel:UILabel = UILabel()
							messageLabel.frame = CGRectMake(0, 0, self.messageScrollView.frame.size.width - 94, CGFloat.max)
							messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
							messageLabel.numberOfLines = 0
							messageLabel.text = self.messageArray[i]
							messageLabel.sizeToFit()
							messageLabel.layer.zPosition = 20
							messageLabel.frame.origin.x = (self.messageScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width
							messageLabel.frame.origin.x = self.messageX
							messageLabel.frame.origin.y = self.messageY
							self.messageScrollView.addSubview(messageLabel)
							self.messageY += messageLabel.frame.size.height + 30
							
							let frameLabel:UILabel = UILabel()
							frameLabel.frame = CGRectMake(self.frameX, self.frameY, messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
							
							frameLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
							frameLabel.layer.masksToBounds = true
							frameLabel.layer.cornerRadius = 10
							self.messageScrollView.addSubview(frameLabel)
							self.frameY += frameLabel.frame.size.height + 20
							
							self.messageScrollView.contentSize = CGSizeMake(width, self.messageY)
							
						}
						
					}
				}
			}
			
		}
		
	
	@IBAction func sendButton(sender: AnyObject) {
		if messageTextView.hasText(){
			let messageDBTable = PFObject(className: "Messages")
			messageDBTable["sender"] = username
			messageDBTable["receiver"] = otherUser
			messageDBTable["message"] = messageTextView.text
			messageDBTable.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
				if success{
					print("message sent")
					self.messageTextView.text = ""
					self.refreshResults()
                    let pushQuery = PFInstallation.query()
                    pushQuery!.whereKey("user", equalTo: "taimoor@gmail.com")
                    
                    // Send push notification to query
                    let push = PFPush()
                    push.setQuery(pushQuery) // Set our Installation query
                    push.setMessage("New Message")
                    push.sendPushInBackground()
				}else{
					print("message not sent")
				}
			})
		}else{
			print("no text")
		}
	}
	
	
	
		override func viewDidLoad() {
			super.viewDidLoad()
			
			let width = self.view.frame.size.width
			let height = self.view.frame.size.height
			
			messageScrollView.frame = CGRectMake(0, 64, width, height-114)
			messageScrollView.layer.zPosition = 20
			frameMessageView.frame = CGRectMake(0, messageScrollView.frame.maxY, width, 50)
			line.frame = CGRectMake(0, 0, width, 1)
			messageTextView.frame = CGRectMake(2, 0, frameMessageView.frame.size.width-51, 48)
			sendButton.center = CGPointMake(frameMessageView.frame.size.width - 30, 24)
			
			scrollViewOriginalY = self.messageScrollView.frame.origin.y
			frameMessageOriginalY = self.frameMessageView.frame.origin.y
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
			
			let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
			tapScrollViewGesture.numberOfTapsRequired = 1
			messageScrollView.addGestureRecognizer(tapScrollViewGesture)
			
			refreshResults()
			
		}
		
		func keyboardWasShown(notification:NSNotification){
			let dict:NSDictionary = notification.userInfo!
			let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
			let rect:CGRect = s.CGRectValue()
			
			UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
				self.messageScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
				self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
				
				let bottomOffset:CGPoint = CGPointMake(0, self.messageScrollView.contentSize.height - self.messageScrollView.bounds.size.height)
				self.messageScrollView.setContentOffset(bottomOffset, animated: true)
				}) { (finished:Bool) -> Void in
					
			}
		}
		
		func keyboardWillHide(notification:NSNotification){
			
			let dict:NSDictionary = notification.userInfo!
			let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
			let rect:CGRect = s.CGRectValue()
			
			UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
				self.messageScrollView.frame.origin.y = self.scrollViewOriginalY
				self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
				
				let bottomOffset:CGPoint = CGPointMake(0, self.messageScrollView.contentSize.height - self.messageScrollView.bounds.size.height)
				self.messageScrollView.setContentOffset(bottomOffset, animated: true)
				}) { (finished:Bool) -> Void in
					
			}
			
		}
		
		func didTapScrollView(){
			self.view.endEditing(true)
		}
		
		override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
		}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
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
