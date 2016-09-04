//
//  DetailViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/2/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import MapKit
import GSImageViewerController

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tiempoLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var rank1: UIImageView!
    @IBOutlet weak var rank2: UIImageView!
    @IBOutlet weak var rank3: UIImageView!
    @IBOutlet weak var rank4: UIImageView!
    @IBOutlet weak var rank5: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    var detailSelected : Business! = nil
    var secundaryLocations : [Business]! = nil

    let locationManager = CLLocationManager()
    
    var mainImage : UIImageView = UIImageView.init(image: UIImage(named: "fastfood"))
    
    let siteDetail : Business! = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadDetails()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        locationManager.location
        
        
    }
    
    func loadDetails() {
        
        imageButton.hnk_setBackgroundImageFromURL(NSURL(string: detailSelected.picture)!, placeholder: UIImage(named: "fastfood.jpg"), format: nil, failure: nil, success: { (image) -> Void in
            self.imageButton.setBackgroundImage(image, forState: .Normal)
        })
        
        mainImage.hnk_setImageFromURL(NSURL(string: detailSelected.picture)!, placeholder: UIImage(named: "fastfood.jpg"), format: nil, failure: nil, success: { (image) -> Void in
            self.imageButton.setBackgroundImage(image, forState: .Normal)
        })
        
        titleLabel.text  = detailSelected.nombre
        tiempoLabel.text = "\(detailSelected.tiempo)"
        precioLabel.text = "\(detailSelected.domicilio)"
        calculateRank(detailSelected.rating)
        createLineButton(detailButton)

        if detailSelected.ubicacion.isEmpty == false {
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let coordeateArray = detailSelected.ubicacion.characters.split{$0 == ","}.map(String.init)
            let detailLocation = Location(title: detailSelected.nombre, coordinate: CLLocationCoordinate2D(latitude: Double(coordeateArray[0] as String)!, longitude: Double(coordeateArray[1] as String)!), info: "", selected: true)
            mapView.addAnnotation(detailLocation)
            let region = MKCoordinateRegion(center: detailLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
        
        if secundaryLocations.count > 0 {
            for i in 0 ..< secundaryLocations.count {
                if secundaryLocations[i].ubicacion.isEmpty == false {
                    let coordeateArray = secundaryLocations[i].ubicacion.characters.split{$0 == ","}.map(String.init)
                    let detailLocation = Location(title: secundaryLocations[i].nombre, coordinate: CLLocationCoordinate2D(latitude: Double(coordeateArray[0] as String)!, longitude: Double(coordeateArray[1] as String)!), info: "", selected: false)
                    mapView.addAnnotation(detailLocation)
                }
            }
        }
    }
    
    func calculateRank(rating: Int) {
        switch rating {
        case 1:
            setRankStar(rank1)
        case 2:
            setRankStar(rank1)
            setRankStar(rank2)
        case 3:
            setRankStar(rank1)
            setRankStar(rank2)
            setRankStar(rank3)
        case 4:
            setRankStar(rank1)
            setRankStar(rank2)
            setRankStar(rank3)
            setRankStar(rank4)
        case 5:
            setRankStar(rank1)
            setRankStar(rank2)
            setRankStar(rank3)
            setRankStar(rank4)
            setRankStar(rank5)
        default:
            unsetRank(rank1)
        }
    }
    
    func setRankStar(sender: UIImageView) {
        sender.image = UIImage(named: "star-filled.png")
    }
    
    //Draw the line at bottom of the button
    func createLineButton(sender: UIButton) {
        let bottomLine = CALayer()
        let width = CGFloat(2.0)
        bottomLine.borderColor = RED_COLOR.CGColor
        bottomLine.frame = CGRect(x: 0.0, y: sender.frame.size.height - width, width: sender.frame.size.width, height: sender.frame.size.height)
        bottomLine.borderWidth = width
        sender.layer.addSublayer(bottomLine)
        sender.layer.masksToBounds = true
        sender.setTitleColor(RED_COLOR, forState: .Normal)
    }
    
    func unsetRank(sender: UIImageView) {}
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
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
        let personal = annotation as! Location
        if #available(iOS 9.0, *) {
            if personal.selected {
                pinView?.pinTintColor = UIColor.orangeColor()
            } else {
                pinView?.pinTintColor = UIColor.blueColor()
            }
        } else {
            if personal.selected {
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
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.first {
            //let span = MKCoordinateSpanMake(0.05, 0.05)
            //let region = MKCoordinateRegion(center: location.coordinate, span: span)
            //mapView.setRegion(region, animated: true)
        }
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
    
    func setupView() {
        createSideMenu(self, story: storyboard!)
        self.navigationController?.navigationBar.barTintColor = RED_COLOR
        let image = UIImage(named: "logo-small.png")
        self.navigationItem.titleView = UIImageView(image: image)
    }
    
    @IBAction func imageZoom(sender: AnyObject) {
        let image = mainImage.image
        let imageInfo   = GSImageInfo(image: image!, imageMode: .AspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender as! UIView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        presentViewController(imageViewer, animated: true, completion: nil)
    }
    
    @IBAction func btnMapZoom(sender: AnyObject) {
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("Map") as! MapViewController
        main.locSelected = detailSelected
        main.locList = secundaryLocations
        self.navigationController?.presentViewController(main, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

