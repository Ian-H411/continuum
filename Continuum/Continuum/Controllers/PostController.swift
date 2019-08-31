//
//  PostController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CloudKit

class PostController{
    
    static let sharedInstance = PostController()
    
    var posts = [Post]()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //crud
    
    //MARK: - CREATE
    
    func addComment(with post: Post, text: String, completion: @escaping (Comment?) -> Void ){
        post.commentCount += 1
        
        guard let record = CKRecord(post: post) else {return}
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        
        operation.qualityOfService = .userInitiated
        
        operation.completionBlock = {
            print("Post Updated")
        }
        publicDB.add(operation)
        
        let newComment = Comment(text: text, post: post)
        let commentRecord = CKRecord(comment: newComment)
        publicDB.save(commentRecord) { (recordOptional, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let record = recordOptional else {completion(nil); return}
            guard let newComment = Comment(ckRecord: record, post: post) else {completion(nil);return}
            post.comments.append(newComment)
            completion(newComment)
            return
        }
        
    }
    
    func createPostWith(caption: String, picture: UIImage, completion: @escaping (Post?) ->Void){
      let newPost =  Post(caption: caption, comments: [], photo: picture)
        guard let record = CKRecord(post: newPost) else {return}
        publicDB.save(record) { (recordOptional, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let record = recordOptional else {completion(nil); return}
            guard let newPost = Post(ckrecord: record) else {completion(nil);return}
            self.posts.append(newPost)
            completion(newPost)
            return
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: postKeys.postObjectKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (unwrappedRecords, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion([])
                return
            }
            guard let records = unwrappedRecords else {completion([]);return}
            var newPosts = [Post]()
            for record in records{
                if let newPost = Post(ckrecord: record) {
                    newPosts.append(newPost)
                }
            }
            self.posts = newPosts
            completion(newPosts)
            return
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]) -> Void){
        
        let postRefence = post.recordID
        let predicate = NSPredicate(format: "%K == %@", commentKeys.postReferenceKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.ckRecordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion([])
                return
            }
            guard let records = records else {completion([]); return}
            var newComments = [Comment]()
            for record in records{
                if let newComment = Comment(ckRecord: record, post: post){
                    newComments.append(newComment)
                }
            }
            post.comments = newComments
            completion(newComments)
            return
        }
    }
    
    func subscribeToNewPosts(completion: @escaping (Bool, Error?) -> Void){
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: postKeys.postObjectKey, predicate: predicate, options: .firesOnRecordCreation)
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "hey look some new posts"
        notification.soundName = "default"
        subscription.notificationInfo = notification
        
        publicDB.save(subscription) { (ckrecord, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                
            }
        }
    }
    
    func subscribeToComments(post: Post, completion: @escaping (Bool, Error?) -> Void){
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [commentKeys.postReferenceKey, post.recordID])
        let subscription = CKQuerySubscription(recordType: commentKeys.commentObjectKey, predicate: predicate, options: .firesOnRecordCreation)
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "someone else commented"
        notification.soundName = "default"
        subscription.notificationInfo = notification
        publicDB.save(subscription) { (record, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
            }
        }
        
    }
}
