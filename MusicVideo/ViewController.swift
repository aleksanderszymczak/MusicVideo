//
//  ViewController.swift
//  MusicVideo
//
//  Created by olos on 27.04.2016.
//  Copyright © 2016 olos. All rights reserved..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/pl/rss/topmusicvideos/limit=10/json",
                     completion: didLoadData)
        
        
    }


    func didLoadData(result: String){
        
        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}

