//
//  CategoriesViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/4/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import SwiftSpinner
import Locksmith

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let searchController = UISearchController(searchResultsController: nil)
    var filteredItems = [String]()
    
    var itemList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let categoriesItem = Locksmith.loadDataForUserAccount("categories")
        itemList = categoriesItem!["categories"] as! [String]
        setupView()
    }
    
    func setupView() {
        //Side Menu Options
        SwiftSpinner.show("cargando...")
        createSideMenu(self, story: storyboard!)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = backItem
        
        let image = UIImage(named: "logo-small.png")
        self.navigationItem.titleView = UIImageView(image: image)
        
        self.navigationController?.navigationBar.barTintColor = RED_COLOR
        
        //Search functions
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        refreshTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Search Bar
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredItems = itemList.filter { category in
            print(searchText.lowercaseString)
            return category.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    //MARK: Table Delegates
    func refreshTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        SwiftSpinner.hide()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            return 280.0
        }
        return 180.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoriesCell") as! CategoriesViewCell
        
        let itemRow : String
        if searchController.active && searchController.searchBar.text != "" {
            itemRow = filteredItems[indexPath.row]
        } else {
            itemRow = itemList[indexPath.row]
        }
        
        cell.titleCategory.text = " \(itemRow)"
        let stringName  = itemRow
        let pictureName = stringName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.imageCell.image = UIImage(named: pictureName)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreen") as! ViewController
        main.isCategories = true
        main.categorySelected = itemList[indexPath.row]
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numSections = 0
        if (self.itemList.count > 0) {
            numSections = 1
        } else {
            let noDataLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No existe información sobre las categorias"
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
    
}

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
