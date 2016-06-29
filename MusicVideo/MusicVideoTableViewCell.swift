//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by olos on 26.05.2016.
//  Copyright © 2016 olos. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    var video: Videos? {
        didSet {
            updateCell()
        }
    }

 
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        
        musicTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        musicTitle.text = video?.vName
        rank.text = String(video!.vRank)
        //musicImage.image = UIImage(named: "noimage")
        
        if video!.vImageData != nil {
            print("Get image from array ...")
            musicImage.image = UIImage(data: video!.vImageData!)
        } else {
            
            GetVideoImage(video!, imageView: musicImage)
            print("Get video in background thread")
        }
        
    }
    
    
    func GetVideoImage(video: Videos, imageView: UIImageView){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            // move back to main queue
            dispatch_async(dispatch_get_main_queue()){
                imageView.image = image
            }
            
        }
       
        
    }


}
