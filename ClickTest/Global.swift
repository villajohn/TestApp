//
//  Global.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import Foundation
import UIKit
import SideMenu


func globalMessage(msgtitle: NSString, msgBody: NSString, delegate: AnyObject?, self: UIViewController) {
    let alert: UIAlertController = UIAlertController()
    alert.title = msgtitle as String
    alert.message = msgBody as String
    let close   = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in })
    alert.addAction(close)
    self.presentViewController(alert, animated: true, completion: nil)
}

func createSideMenu(self: UIViewController, story: UIStoryboard) {
    SideMenuManager.menuRightNavigationController = story.instantiateViewControllerWithIdentifier("MenuNavigation") as? UISideMenuNavigationController
    
    SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
    SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    
    SideMenuManager.menuPresentMode = .MenuDissolveIn
    SideMenuManager.menuShadowOpacity = 0.5
    SideMenuManager.menuFadeStatusBar = true
    SideMenuManager.menuWidth = UIScreen.mainScreen().bounds.width
}

//Draw the line at bottom of the button
func createLineButton(sender: UIButton) {
    let bottomLine = CALayer()
    let width = CGFloat(2.0)
    bottomLine.borderColor = RED_COLOR.CGColor
    bottomLine.frame = CGRect(x: 0.0, y: sender.frame.size.height - width, width: sender.frame.size.width, height: 1.0)
    bottomLine.borderWidth = width
    sender.layer.addSublayer(bottomLine)
    sender.layer.masksToBounds = true
    sender.setTitleColor(RED_COLOR, forState: .Normal)
}