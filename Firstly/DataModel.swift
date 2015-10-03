//
//  DataModel.swift
//  Firstly
//
//  Created by MichaelSelsky on 10/3/15.
//  Copyright © 2015 self. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    dynamic var imageData: NSData?
    dynamic var postText: String
    dynamic var poster: User
    dynamic var postDate: NSDate
    dynamic var postID: String
    var image: UIImage? {
        guard let imageData = imageData  else {
            return nil
        }
        let i = UIImage(data: imageData)
        return i;
    }
    override static func primaryKey() -> String? {
        return "postID"
    }
    
    required init() {
        self.postText = ""
        self.poster = User()
        self.postDate = NSDate()
        self.postID = ""
        self.imageData = nil
        super.init()
    }
    
    init(postText: String, poster: User, postDate: NSDate, postID: String, imageData: NSData?){
        self.postText = postText
        self.poster = poster
        self.postDate = postDate
        self.postID = postID
        self.imageData = imageData
        super.init()
    }
    
    convenience init(postText: String, poster: User, postDate: NSDate, postID: String, image: UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        self.init(postText: postText, poster: poster, postDate:postDate, postID: postID, imageData: imageData)
    }
}

class User: Object {
    dynamic var userID: String
    dynamic var username: String
    var posts: [Post] {
        return linkingObjects(Post.self, forProperty: "poster")
    }
    required init() {
        userID = ""
        username = ""
        super.init()
    }
    init(username: String, userID: String) {
        self.username = username
        self.userID = userID
        super.init()
    }
}
