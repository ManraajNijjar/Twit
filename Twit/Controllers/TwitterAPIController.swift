//
//  TwitterAPIController.swift
//  Twit
//
//  Created by Manraaj Nijjar on 10/16/17.
//  Copyright © 2017 Manraaj Nijjar. All rights reserved.
//

import Foundation
import TwitterCore
import TwitterKit

class TwitterAPIController {
    static let sharedInstance = TwitterAPIController()

    var twitterClient = TWTRAPIClient()
    
    func getUserData(userID: String, completionHandlerForUser: @escaping (_ userResult: TWTRUser?, _ error: Error?) -> Void){
        
        twitterClient.loadUser(withID: userID) { (user, error) -> Void in
            // handle the response or error
            if error == nil {
                completionHandlerForUser(user, nil)
            }
            
            if error != nil {
                print(error!)
                completionHandlerForUser(nil, error)
            }
        }
    }
    
    func getImageForUserID(userID: String, size: String, imageCompletionHandler: @escaping (_ userImage: UIImage?) -> Void) {
        
        getUserData(userID: userID) { (user, error) in
            if (error != nil) {
                imageCompletionHandler(nil)
            }
            if error == nil {
                if size == "Large" {
                    imageCompletionHandler(self.retrieveImageFromTwitter(imageURL: (user?.profileImageLargeURL)!))
                } else if size == "Mini" {
                    imageCompletionHandler(self.retrieveImageFromTwitter(imageURL: (user?.profileImageMiniURL)!))
                } else {
                    imageCompletionHandler(self.retrieveImageFromTwitter(imageURL: (user?.profileImageURL)!))
                }
            }
        }
    }
    
    func retrieveImageFromTwitter(imageURL: String) -> UIImage? {
        let photoURL = URL(string: imageURL)
        if let imageData = try? Data(contentsOf: photoURL!) {
            return UIImage(data:imageData as Data,scale:1.0)
        } else {
            return nil
        }
    }
}
