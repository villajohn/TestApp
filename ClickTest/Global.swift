//
//  Global.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import Foundation
import UIKit


func globalMessage(msgtitle: NSString, msgBody: NSString, delegate: AnyObject?, self: UIViewController) {
    let alert: UIAlertController = UIAlertController()
    alert.title = msgtitle as String
    alert.message = msgBody as String
    let close   = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in })
    alert.addAction(close)
    self.presentViewController(alert, animated: true, completion: nil)
}