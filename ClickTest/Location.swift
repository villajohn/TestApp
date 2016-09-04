//
//  Location.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/2/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Location: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var selected: Bool
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, selected: Bool) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.selected = selected
    }
}