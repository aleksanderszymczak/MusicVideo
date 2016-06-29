//
//  ViewController.swift
//  MusicVideo
//
//  Created by olos on 27.04.2016.
//  Copyright © 2016 olos. All rights reserved..
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var videos = [Videos]()
    


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
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
        tableView.reloadData()
    }
    
 
    func reachabilityStatusChanged(){
        
        switch reachabilityStatus {
        case NOACCESS :
            view.backgroundColor = UIColor.redColor()
            
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
            view.backgroundColor = UIColor.greenColor()
            
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    
    func runAPI(){
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/pl/rss/topmusicvideos/limit=10/json",
                     completion: didLoadData)
    }
    
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        return videos.count
        
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let video = videos[indexPath.row]
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.vName
        return cell
    }
    
    
}

