//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var landingPad: Post?{
        didSet{
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = landingPad else {return 0}
        return post.comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let post = landingPad else {return UITableViewCell()}
        let comment = post.comments[indexPath.row]
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = "\(comment.timeStamp)"
        return cell
    }
    
    //MARK: - Helper
    
    func updateViews(){
        loadViewIfNeeded()
        guard let post = landingPad else {return}
        guard let image = post.photo else {return}
        postImageView.image = image
        captionLabel.text = post.caption
        tableView.reloadData()
    }
    
    func addCommentAlert(){
        let alert = UIAlertController(title: "Add a Comment", message: "add a comment to this post", preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "write a comment"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        let alertAddAction = UIAlertAction(title: "add", style: .default) { (_) in
            guard let comment = alert.textFields?.first?.text, !comment.isEmpty, let post = self.landingPad else {return}
                PostController.sharedInstance.addComment(with: post, text: comment, completion: { (comment) in
                })
        self.tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(alertAddAction)
        self.present(alert, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        addCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
}
