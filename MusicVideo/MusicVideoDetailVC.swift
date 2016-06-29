//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by olos on 06.06.2016.
//  Copyright © 2016 olos. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {
    
    var videos:Videos!
    var securitySwich: Bool = false
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTVC.preferedFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        
        title = videos.vArtist
        vName.text = videos.vName
        vGenre.text = videos.vGenre
        vPrice.text = videos.vPrice
        vRights.text = videos.vRights
        
        if videos.vImageData != nil{
            videoImage.image = UIImage(data: videos.vImageData!)
        } else {
            videoImage.image = UIImage(named: "noimage")
        }
    
    }
    
    
    func preferedFontChange() {
        
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: videos.vVideoUrl)!
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) { 
            playerViewController.player?.play()
        }
        
    }
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwich = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        switch securitySwich {
        case true:
            touchIdChk()
        default:
            shareMedia()
        }
    
    }
    
    func touchIdChk() {
        
        // Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "continue", style: .Cancel, handler: nil))
        
        // Create local authentication context
        let context = LAContext()
        var touchIDError = NSError?()
        let reasonString = "Touch-ID authentication is needed to share info on Social Media"
        
        // Check if we can access to local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIDError){
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.shareMedia()
                    }
                } else {
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)!{
                        
                    case .AppCancel:
                        alert.message = "Authentication s cancelled by aplication"
                    case.AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                    case .InvalidContext:
                        alert.message = "The context is invalid"
                    case .PasscodeNotSet:
                        alert.message = "Passcode has not been set"
                    default:
                        alert.message = "Local Authentication not available"
                    }
                    // show the alert
                    dispatch_async(dispatch_get_main_queue()){ [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
            })
        } else {
            // unable to access local devide authentication
            alert.title = "Error!"
            
            switch LAError(rawValue: touchIDError!.code)! {
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
            case .TouchIDNotAvailable:
                alert.message = "Touch ID is not available on device"
            case .PasscodeNotSet:
                alert.message = "Passcode is not set"
            case.InvalidContext:
                alert.message = "The context is invalid"
            default:
                alert.message = "Local Authentication not available"
            }
            
            //show the alert
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        
        
        
        
        
        
    }
    
    func shareMedia() {
       
        let activity1 = "Heve you had opportunity to see This Music Video"
        let activity2 = "\(videos.vName) by \(videos.vArtist)"
        let activity3 = "Watch it and tell me what you think"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "(Shared with the Music Video App - Step it up!)"
        
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, item, error) in
            
            if activity == UIActivityTypeMail {
                print("email selected")
            }
            
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
   

   }
