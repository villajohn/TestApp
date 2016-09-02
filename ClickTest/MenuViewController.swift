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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
