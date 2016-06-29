//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by olos on 23.05.2016.
//  Copyright © 2016 olos. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {

    var videos = [Videos]()
    
    var filterSearch = [Videos]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    var limit = 10
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.preferedFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        reachabilityStatusChanged()
        
        
        
    }
    
    
    func didLoadData(videos: [Videos]){
        
        print(reachabilityStatus)
        
        self.videos = videos
        
        for item in videos {
            print("name = \(item.vName)")
        }
        
        for (value, item) in videos.enumerate() {
            print(value, "name = \(item.vName)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        title = "The iTunes Top \(videos.count) Music Videos"
        
        // Setup the Search Controller
        // resultSearchController.searchResultUpdater = self
        
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = .Prominent
        
        // add search bar to table view
        tableView.tableHeaderView = resultSearchController.searchBar

        tableView.reloadData()
    }
    
    
    func reachabilityStatusChanged(){
        
        switch reachabilityStatus {
        case NOACCESS :
            //view.backgroundColor = UIColor.redColor()
            
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { action -> () in
                    print("Cancel")
                })
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { action -> () in
                    print("Delete")
                })
                
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action -> Void in
                    print("OK")
                })
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        default:
            //view.backgroundColor = UIColor.greenColor()
            
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func preferedFontChange(){
        
    print("Prefered font has changed")
        
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
       refreshControl?.endRefreshing()
        runAPI()
    }
    
    
    func getAPICount() {
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
        
    }
    
    func runAPI() {
        // Call API
        getAPICount()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json",
                     completion: didLoadData)

    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "preferedFontChange", object: nil)
        
    }

    // MARK DATA SOURCE
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active {
            return filterSearch.count
        }
        return videos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.active {
            cell.video = filterSearch[indexPath.row]
        } else {
            
            cell.video = videos[indexPath.row]
        }
        return cell
    }
    
    
     // MARK: - Navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if segue.identifier == "musicDetail" {
            
            if let indexpath = tableView.indexPathForSelectedRow {
                let video: Videos
                
                if resultSearchController.active {
                    video = filterSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }

                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
        
     }
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  

}
