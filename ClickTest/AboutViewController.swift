//
//  AboutViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/4/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import GSImageViewerController

class AboutViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setupView() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backItem
        
        let image = UIImage(named: "logo-small.png")
        self.navigationItem.titleView = UIImageView(image: image)
        self.title = "Acerca De"
        
        self.navigationController?.navigationBar.barTintColor = RED_COLOR

    }
    
    @IBAction func zoomFirstPicture(sender: AnyObject) {
        let image1 : UIImageView = UIImageView.init(image: UIImage(named: "about1"))
        let image = image1.image
        let imageInfo   = GSImageInfo(image: image!, imageMode: .AspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender as! UIView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        presentViewController(imageViewer, animated: true, completion: nil)
    }
    
    @IBAction func zoomSecondPicture(sender: AnyObject) {
        let image1 : UIImageView = UIImageView.init(image: UIImage(named: "about2"))
        let image = image1.image
        let imageInfo   = GSImageInfo(image: image!, imageMode: .AspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender as! UIView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        presentViewController(imageViewer, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
