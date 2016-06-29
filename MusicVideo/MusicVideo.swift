//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by olos on 06.05.2016.
//  Copyright © 2016 olos. All rights reserved.
//

import Foundation


class Videos {
    
    var vRank = 0
    
    // data Encapsulation
    
    private var _vName:String
    private var _vImageUrl:String
    private var _vVideoUrl:String
    private var _vRights:String
    private var _vPrice:String
    private var _vArtist:String
    private var _vImid:String
    private var _vGenre:String
    private var _vLinkToiTunes:String
    private var _vReleaseDte:String
    
    var vImageData:NSData?
    
    // Make a getter
    
    var vName:String {
        return _vName
    }
    
    var vImageUrl:String {
        return _vImageUrl
    }
    
    var vVideoUrl:String {
        return _vVideoUrl
    }
    
    var vRights:String {
        return _vRights
    }
    
    var vPrice:String {
        return _vPrice
    }
    
    var vArtist:String{
        return _vArtist
    }
    
    var vImid:String{
        return _vImid
    }
    
    var vGenre:String{
        return _vGenre
    }
    
    var vLinkToiTunes:String{
        return _vLinkToiTunes
    }
    
    var vReleaseDte:String{
        return _vReleaseDte
    }
    
    
    
    init(data: JSONDictionary) {
        
        // Video name
        
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
            self._vName = vName
            
        } else {
            
            _vName = ""
        }
        
        
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
                _vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
            
        } else {
           
            _vImageUrl = ""
        }
        
        if let video = data["link"] as? JSONArray,
        vUrl = video[1] as? JSONDictionary,
        vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
            self._vVideoUrl = vVideoUrl
        } else {
            
            _vVideoUrl = ""
        }
        
        
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
            self._vRights = vRights
        } else {
            _vRights = ""
        }
        
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
            self._vPrice = vPrice
        } else {
            _vPrice = ""
        }
        
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
            self._vArtist = vArtist
        } else {
            _vArtist = ""
        }
        
        if let imid = data["id"] as? JSONDictionary,
            vid = imid["attributes"] as? JSONDictionary,
            vImid = vid["im:id"] as? String {
            self._vImid = vImid
        } else {
            _vImid = ""
        }
        
        if let genre = data["category"] as? JSONDictionary,
            gen = genre["attributes"] as? JSONDictionary,
            vGenre = gen["term"] as? String {
            self._vGenre = vGenre
        } else {
            _vGenre = ""
        }
        
        if let linkToiTunes = data["id"] as? JSONDictionary,
            vLinkToiTunes = linkToiTunes["label"] as? String {
            self._vLinkToiTunes = vLinkToiTunes
        } else {
            _vLinkToiTunes = ""
        }
        
        if let releaseDte = data["im:releaseDate"] as? JSONDictionary,
            release = releaseDte["attributes"] as? JSONDictionary,
            vReleaseDte = release["label"] as? String {
            self._vReleaseDte = vReleaseDte
        } else {
            _vReleaseDte = ""
        }
        
        
    }
    
}