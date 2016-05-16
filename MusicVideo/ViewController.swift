//
//  ViewController.swift
//  MusicVideo
//
//  Created by olos on 27.04.2016.
//  Copyright © 2016 olos. All rights reserved..
//

import UIKit

class ViewController: UIViewController {
    
    var videos = [Videos]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/pl/rss/topmusicvideos/limit=10/json",
                     completion: didLoadData)
        
        
    }


    func didLoadData(videos: [Videos]){
        
        self.videos = videos
        
        for item in videos {
            print("name = \(item.vName)")
        }
        
        for (value, item) in videos.enumerate() {
            print(value, "name = \(item.vName)")
        }
        
    }
}

