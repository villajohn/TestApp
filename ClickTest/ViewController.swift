//
//  ViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import SwiftSpinner
import Haneke
import SideMenu

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemList = [Product]()
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredItems = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewControllerWithIdentifier("MenuNavigation") as? UISideMenuNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuPresentMode = .MenuDissolveIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuFadeStatusBar = true
        SideMenuManager.menuWidth = UIScreen.mainScreen().bounds.width
            
        //Search functions
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationController?.navigationBar.barTintColor = RED_COLOR
        getData()
    }
    
    func getData() {
        SwiftSpinner.show("cargando...")
        let parameters = [] as AnyObject
        let urlMethod = "\(URL_SERVER)"
        makeRequest(urlMethod, metodo: "GET", params: parameters) {
            response, error in
            if let ans = response {
                if ans.count > 0 {
                    for i in 0 ..< ans.count {
                        let categoria  = ans[i]["categorias"] as! String
                        let domicilio  = Double(ans[i]["domicilio"] as! String)
                        let logo       = ans[i]["logo_path"] as! String
                        let nombre     = ans[i]["nombre"] as! String
                        let tiempo     = Int(ans[i]["tiempo_domicilio"] as! String)
                        let rating     = Int(ans[i]["rating"] as! String)
                        let ubicacion  = ans[i]["ubicacion_txt"] as! String
                        let urlDetalle = ans[i]["url_detalle"] as! String
                        let detail = Product(categoria: categoria, domicilio: domicilio!, urlDetalle: urlDetalle, picture: logo, nombre: nombre, rating: rating!, tiempo: tiempo!, ubicacion: ubicacion, favorite: false)
                        self.itemList.append(detail)
                    }
                    self.refreshTable()

                } else {
                    globalMessage(APP_NAME, msgBody: "No se han encontrado resultados", delegate: nil, self: self)
                }
                SwiftSpinner.hide()
            } else {
                SwiftSpinner.hide()
                globalMessage(APP_NAME, msgBody: NETWORK_MESSAGE, delegate: nil, self: self)
            }
        }
    }
    
    //MARK: Table Delegate
    func refreshTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainCell") as! MainTableViewCell
        
        let itemRow : Product
        if searchController.active && searchController.searchBar.text != "" {
            itemRow = filteredItems[indexPath.row]
        } else {
            itemRow = itemList[indexPath.row]
        }
        
        cell.nameLabel.text  = itemRow.nombre
        cell.priceLabel.text = "\(itemRow.domicilio)"
        
        if itemRow.favorite == true {
            cell.favoriteButton.imageView?.image = UIImage(named: "icon-heart-red.png")
        }
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(self.actionFavorite(_:)), forControlEvents: .TouchUpInside)
        
        cell.itemImage.hnk_setImageFromURL(NSURL(string: itemRow.picture)!, placeholder: UIImage(named: "fastfood.jpg"), format: nil, failure: nil, success: { (image) -> Void in
            cell.itemImage.image = image
        })
        
        return cell
    }
    
    func actionFavorite(sender: UIButton) {
        itemList[sender.tag].favorite = true

        //print(sender.tag)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numSections = 0
        if (self.itemList.count > 0) {
            numSections = 1
        } else {
            let noDataLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No información para mostrar"
            noDataLabel.numberOfLines = 6
            noDataLabel.textColor = UIColor.redColor()
            noDataLabel.textAlignment = .Center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }
        return numSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredItems.count
        }
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if filteredItems.count == 0 {
            cell.alpha = 0
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
            cell.layer.transform = transform
            
            UIView.animateWithDuration(0.5) {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Search Bar
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredItems = itemList.filter { product in
            return product.nombre.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }


}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

