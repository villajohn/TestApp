//
//  CommentsViewController.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/4/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit
import SwiftSpinner

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var itemList = [Comment]()
    var detailSelected : Business! = nil

    override func viewWillAppear(animated: Bool) {
        getComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    func setupView() {
        let image = UIImage(named: "logo-small.png")
        self.navigationItem.titleView = UIImageView(image: image)
        createLineButton(commentsButton)
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "plus-sign"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 35, 35)
        btnName.addTarget(self, action: #selector(self.addComment), forControlEvents: .TouchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addComment() {
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("NewComment") as! NewCommentViewController
        main.relation = detailSelected.nombre
        self.navigationController?.presentViewController(main, animated: true, completion: nil)
    }
    
    //MARK: Table Delegate
    func refreshTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentsTableViewCell
        
        let item = itemList[indexPath.row]
        cell.nameField.text = item.name
        cell.commentField.text = item.comment
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numSections = 0
        if (self.itemList.count > 0) {
            numSections = 1
        } else {
            let noDataLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No hay comentarios disponibles"
            noDataLabel.numberOfLines = 6
            noDataLabel.textColor = UIColor.redColor()
            noDataLabel.textAlignment = .Center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }
        return numSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    //Network Request
    func getComments() {
        SwiftSpinner.show("cargando...")
        let parameters = ["relation": detailSelected.nombre] as AnyObject
        let urlMethod  = "\(URL_COMMENT)getComments"
        makeRequest(urlMethod, metodo: "GET", params: parameters) {
            response, error in
            self.itemList.removeAll()
            if let ans = response {
                if ans.count > 0 {
                    for i in 0 ..< ans.count {
                        let name    = ans[i]["name"] as! String
                        let comment = ans[i]["comment"] as! String
                        let item    = Comment(name: name, comment: comment)
                        self.itemList.append(item)
                    }
                }
                self.refreshTable()
                SwiftSpinner.hide()
            } else {
                SwiftSpinner.hide()
                globalMessage(APP_NAME, msgBody: NETWORK_MESSAGE, delegate: nil, self: self)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
