//
//  MenuViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var productsList: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var backTop: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        let _ = UIImage(named: "background-menu.jpg")?.drawInRect(self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        productsList.layer.cornerRadius     = 10.0
        aboutButton.layer.cornerRadius      = 10.0
        categoriesButton.layer.cornerRadius = 10.0
        favoritesButton.layer.cornerRadius  = 10.0
        backTop.backgroundColor = RED_COLOR
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backItem
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    func dismissMenu() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFavorites" {
            let destination = segue.destinationViewController as! ViewController
            destination.isFavorites = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
