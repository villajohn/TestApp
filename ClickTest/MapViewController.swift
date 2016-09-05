//
//  MapViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/3/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locSelected : Business! = nil
    var locList     : [Business]! = nil
    
    let locationManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil

    override func viewWillAppear(animated: Bool) {
        
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.location
    }
    
    
    //MARK: Map Delegates
    func setupMap() {
        mapView.delegate = self
        if locSelected != nil && locSelected.ubicacion.isEmpty == false {
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let coordeateArray = locSelected.ubicacion.characters.split{$0 == ","}.map(String.init)
            let detailLocation = Location(title: locSelected.nombre, coordinate: CLLocationCoordinate2D(latitude: Double(coordeateArray[0] as String)!, longitude: Double(coordeateArray[1] as String)!), info: "", selected: true)
            mapView.addAnnotation(detailLocation)
            
            let region = MKCoordinateRegion(center: detailLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        for i in 0 ..< locList.count {
            if locList[i].ubicacion.isEmpty == false {
                let coordeateArray = locList[i].ubicacion.characters.split{$0 == ","}.map(String.init)
                let detailLocation = Location(title: locList[i].nombre, coordinate: CLLocationCoordinate2D(latitude: Double(coordeateArray[0] as String)!, longitude: Double(coordeateArray[1] as String)!), info: "", selected: false)
                mapView.addAnnotation(detailLocation)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        //return annotationView
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        let personalPin = annotation as! Location
        if #available(iOS 9.0, *) {
            if personalPin.selected == true {
                pinView?.pinTintColor = UIColor.orangeColor()
            } else {
                pinView?.pinTintColor = UIColor.blueColor()
            }
        } else {
            if personalPin.selected == true {
                pinView?.tintColor = UIColor.orangeColor()
            } else {
                pinView?.tintColor = UIColor.blueColor()
            }
        }
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "icon-car.png"), forState: .Normal)
        //button.addTarget(self, action: #selector(self.getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location  = view.annotation as! Location
        
        let geoCoder = CLGeocoder()
        let locationFixed = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(locationFixed, completionHandler: { (placeMarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placeMarks![0]
            
            self.selectedPin = MKPlacemark(coordinate: location.coordinate, addressDictionary: placeMark.addressDictionary as? [String:AnyObject])
            self.getDirections()
        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
