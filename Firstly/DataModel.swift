//
//  DataModel.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import Foundation
import RealmSwift

class DataModel {
    var realm: Realm?
    init() {
        var r: Realm?
        do {
            r = try Realm()
        } catch {
            print(error)
        }
        self.realm = r
    }
}

class Image: Object {
    dynamic var imageData: NSData
    required init() {
        self.imageData = NSData()
        super.init()
    }
    
    init(imageData: NSData) {
        self.imageData = imageData
        super.init()
    }
}

class Post: Object {
    dynamic var imageData: Image? = nil
    dynamic var postText: String = ""
    dynamic var poster: User? = nil
    dynamic var postDate: NSDate = NSDate()
    dynamic var postID: String = ""
    var image: UIImage? {
        guard let imageData = imageData  else {
            return nil
        }
        let i = UIImage(data: imageData.imageData)
        return i;
    }
    override static func primaryKey() -> String? {
        return "postID"
    }
    
    convenience init(postText: String, poster: User, postDate: NSDate, postID: String, imageData: NSData?){
        self.init()
        self.postText = postText
        self.poster = poster
        self.postDate = postDate
        self.postID = postID
        if let imageData = imageData {
            self.imageData = Image(imageData: imageData)
        }
    }
    
    convenience init(postText: String, poster: User, postDate: NSDate, postID: String, image: UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        self.init(postText: postText, poster: poster, postDate:postDate, postID: postID, imageData: imageData)
    }
    
    func formattedDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        return dateFormatter.stringFromDate(self.postDate)
    }
}

class User: Object {
    dynamic var userID: String = ""
    dynamic var username: String = ""
    var posts: [Post] {
        return linkingObjects(Post.self, forProperty: "poster")
    }
    convenience init(username: String, userID: String) {
        self.init()
        self.username = username
        self.userID = userID
    }
}
