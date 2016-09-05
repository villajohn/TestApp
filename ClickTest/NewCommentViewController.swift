//
//  NewCommentViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/4/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import SwiftSpinner

class NewCommentViewController: UIViewController {

    var relation : String! = nil
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameText.layer.borderColor = UIColor.lightGrayColor().CGColor
        nameText.layer.borderWidth = 0.5
        nameText.layer.cornerRadius = 5.0
        commentText.layer.cornerRadius = 5.0
        commentText.layer.borderWidth = 0.5
        commentText.layer.borderColor = UIColor.lightGrayColor().CGColor
        viewMain.layer.cornerRadius = 5.0
        buttonSend.backgroundColor = BLUE_COLOR
        buttonSend.layer.cornerRadius = 5.0
        
        hideKeyboardWhenTappedAround()
    }

    
    @IBAction func dismissAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sendFormAction(sender: AnyObject) {
        if commentText.text.isEmpty == false && nameText.text?.isEmpty == false {
            sendComment()
        } else {
            globalMessage(APP_NAME, msgBody: "Los campos de Nombre y Comentario son obligatorios", delegate: nil, self: self)
        }
    }
    
    //Mark: Network Request
    func sendComment() {
        SwiftSpinner.show("guardando...")
        let parameters = ["name": nameText.text, "comment": commentText.text, "relation": relation!] as AnyObject
        let urlMethod = "\(URL_COMMENT)newComment"
        makeRequest(urlMethod, metodo: "POST", params: parameters) {
            response, error in
            if let _ = response {
                SwiftSpinner.hide()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                SwiftSpinner.hide()
                globalMessage(APP_NAME, msgBody: NETWORK_MESSAGE, delegate: nil, self: self)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
