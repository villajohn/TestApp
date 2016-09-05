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
import Locksmith

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
    @IBOutlet weak var favoriteButton: UIButton!
    
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
        tiempoLabel.text = "\(detailSelected.tiempo) minutos"
        precioLabel.text = "$ \(detailSelected.domicilio)"
        calculateRank(detailSelected.rating)
        createLineButton(detailButton)
        
        if Locksmith.loadDataForUserAccount(detailSelected.nombre) != nil {
            favoriteButton.setImage(UIImage(named: "heart-red"), forState: .Normal)
        }
            
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
    
    func unsetRank(sender: UIImageView) {}
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
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
    
    @IBAction func favoriteAction(sender: AnyObject) {
        if Locksmith.loadDataForUserAccount(detailSelected.nombre) != nil {
            do {
                try Locksmith.deleteDataForUserAccount(detailSelected.nombre)
                favoriteButton.setImage(UIImage(named: "heart_empty"), forState: .Normal)
            } catch {
                globalMessage("Error", msgBody: "No es posible procesar la petición, intente de nuevo", delegate: nil, self: self)
            }
        } else {
            do {
                try Locksmith.saveData(["name": detailSelected.nombre], forUserAccount: detailSelected.nombre)
                favoriteButton.setImage(UIImage(named: "heart-red"), forState: .Normal)
            } catch {
                globalMessage("Error", msgBody: "No es posible procesar la petición, intente de nuevo", delegate: nil, self: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowComments" {
            let destination = segue.destinationViewController as! CommentsViewController
            destination.detailSelected = detailSelected
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

