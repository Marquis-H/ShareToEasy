//
//  HistoryTableViewController.swift
//  ShareToEasy
//
//  Created by Marquis on 15/9/11.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: Properties
    var historys = [HistoryShare]()
    var isFirstTableView: Bool = false
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }else {
            return nil
        }
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstTableView = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(2) * 20 + 32, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        loadHistoryShareMeals()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTableView == true {
            isFirstTableView = false
        }else{
            historys = []
            loadHistoryShareMeals()
            tableView.reloadData()
        }
    }

    func loadHistoryShareMeals(){
        //遍历查询结果
        for info:HistoryShareData in self.initHistoryShare() as! [HistoryShareData]{
            let photo = UIImage(named: "\(info.status)")!
            let text: String = info.text
            let dataFormatter = NSDateFormatter()
            dataFormatter.dateFormat = "MM-dd HH:mm"
            let time: String = dataFormatter.stringFromDate(info.createdAt)
            let meal = HistoryShare(hSharePlatformName: "ShareTo=>"+info.platform, photo: photo, hShareTime: time, hShareText: text)!
            historys += [meal]
        }
    }
    
    func initHistoryShare() -> AnyObject{
        var error: NSError?
        //声明数据请求
        var fetchRequest:NSFetchRequest = NSFetchRequest()
        fetchRequest.fetchOffset = 0
        //声明一个实体结构
        var entity:NSEntityDescription? = NSEntityDescription.entityForName("HistoryShareData", inManagedObjectContext: self.managedObjectContext!)
        //设置数据请求的实体
        fetchRequest.entity = entity
        //查询操作
        var fetchedObjects: [AnyObject]? = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        //遍历查询结果
        return fetchedObjects!;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return historys.count
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        let history = historys[indexPath.row]
        
        cell.HSharePlatform.text = history.hSharePlatformName
        cell.HIsSuccess.image = history.photo
        cell.HShareTime.text = history.hShareTime
        cell.HShareText.text = history.hShareText
//        cell.userInteractionEnabled = false
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.initHistoryShare().objectAtIndexPath(indexPath) as! NSManagedObject
        cell.textLabel!.text = object.valueForKey("timeStamp")!.description
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //遍历查询结果
            var i: Int = 0
            for info:HistoryShareData in self.initHistoryShare() as! [HistoryShareData]{
                if indexPath.row == i{
                    historys.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.managedObjectContext?.deleteObject(info)
                    break
                }
                i++
            }

            var error: NSError? = nil
            if !self.managedObjectContext!.save(&error) {
                abort()
            }
        }
    }

    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            println("")
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
