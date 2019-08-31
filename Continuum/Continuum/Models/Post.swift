//
//  Post.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

import UIKit.UIImage

import CloudKit

struct postKeys {
    static let postObjectKey = "post"
    static let timeStampKey =  "timeStamp"
    static let captionKey = "caption"
    static let recordIDKey = "ckRecordID"
    static let imageAssestKey = "ckImageAssest"
    static let commentKey = "comments"
    static let commentCountKey = "commentKey"

}


class Post:SearchableRecord{
    //MARK: - Protocol procedures
    func matches(searchTerm: String) -> Bool {
        if self.caption.contains(searchTerm){
            return true
        }
        for comment in self.comments{
            if comment.text.contains(searchTerm){
                return true
            }
        }
        return false
    }
    
    //MARK: - Properties
    var photoData: Data?
    
    let timeStamp: Date
    
    var caption: String
    
    var comments: [Comment]
    
    var commentCount:Int
    
    var recordID: CKRecord.ID
    
    var photo: UIImage?{
        get{
            guard let photoData = photoData else{return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset{
        get{
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do{
                try photoData?.write(to: fileURL)
            } catch {
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    
    
    init(caption: String,timeStamp: Date = Date(), comments: [Comment] = [], photo: UIImage, ckRecord: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0 ) {
        self.timeStamp = timeStamp
        self.caption = caption
        self.comments = comments
        self.recordID = ckRecord
        self.commentCount = commentCount
        self.photo = photo
    }
    
    
    init?(ckrecord: CKRecord){
        guard let caption = ckrecord[postKeys.captionKey] as? String,
        let timeStamp = ckrecord[postKeys.timeStampKey] as? Date,
        let imageAsset = ckrecord[postKeys.imageAssestKey] as? CKAsset,
        let commentCount = ckrecord[postKeys.commentKey] as? Int
        else {return nil}
        self.caption = caption
        self.timeStamp = timeStamp
        self.recordID = ckrecord.recordID
        self.comments = []
        self.commentCount = commentCount
        guard let imageURL = imageAsset.fileURL else {return}
        do {
            self.photoData = try Data(contentsOf: imageURL)
        } catch{
            print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
        }
    }
    
}
extension CKRecord {
    convenience init?(post: Post){
        self.init(recordType: postKeys.postObjectKey, recordID: post.recordID)
        self.setValue(post.timeStamp, forKey: postKeys.timeStampKey)
        self.setValue(post.caption, forKey: postKeys.captionKey)
        self.setValue(post.imageAsset, forKey: postKeys.imageAssestKey)
        self.setValue(post.commentCount, forKey: postKeys.commentCountKey)
    }
}
