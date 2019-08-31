//
//  Comment.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CloudKit

struct commentKeys {
    static let commentObjectKey = "comment"
    
    static let textKey = "text"
    
    static let timeStampKey = "timeStamp"
    
    static let ckRecordIDKEY = "ckRecordID"
    
    static let postKey = "post"
    
    static let postReferenceKey = "postReference"
}

class Comment:SearchableRecord{
    func matches(searchTerm: String) -> Bool {
        return self.text.contains(searchTerm)
    }
    
    var text: String
    
    var timeStamp: Date
    
    weak var post: Post?
    
    var ckRecordID: CKRecord.ID
    
    var postReference: CKRecord.Reference?{
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text:String, timeStamp: Date = Date(), post:Post, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.text = text
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
        self.post = post
        
    }
    init?(ckRecord: CKRecord, post: Post){
        guard let text = ckRecord[commentKeys.textKey] as? String,
            let timeStamp = ckRecord[commentKeys.timeStampKey] as? Date,
            let ckRecordID = ckRecord[commentKeys.ckRecordIDKEY] as? CKRecord.ID
            else {return nil}
        self.text = text
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
        self.post = post
        
    }
}


extension CKRecord{
    convenience init(comment: Comment){
        self.init(recordType: commentKeys.commentObjectKey, recordID: comment.ckRecordID)
        self.setValue(comment.text, forKey: commentKeys.textKey)
        self.setValue(comment.timeStamp, forKey: commentKeys.timeStampKey)
        self.setValue(comment.postReference, forKey: commentKeys.postReferenceKey)
    }
}
