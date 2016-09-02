//
//  DetailViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/2/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mapVIew: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 4.666127599999999, longitude: -74.05630480000002), info: "Home to the 2012 Summer Olympics.")
        mapVIew.addAnnotation(london)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
