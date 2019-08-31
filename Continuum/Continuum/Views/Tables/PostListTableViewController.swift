//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    //MARK: - OUTLETS AND VARIABLES
    @IBOutlet weak var searchBarLabel: UISearchBar!
    
    var resultsArray = [Post]()
    
    var isSearching: Bool = false
    
    var dataSource:[Post]{
        return isSearching ? resultsArray : PostController.sharedInstance.posts
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarLabel.delegate = self
        requestFullSync { (success) in
        }

    }
    override func viewWillAppear(_ animated: Bool) {        super.viewWillAppear(true)
        resultsArray = PostController.sharedInstance.posts
        tableView.reloadData()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return dataSource.count
    }
   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as?  PostTableViewCell else {return UITableViewCell()}
       let post = dataSource[indexPath.row]
        cell.post = post
        return cell
    }

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                if let toDetailVC = segue.destination as? PostDetailTableViewController{
                    let postToSend = dataSource[indexPath.row]
                    toDetailVC.landingPad = postToSend
                }
            }
        }
    }
//MARK: - Helpers
    
    func requestFullSync(completion: (Bool)-> Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.sharedInstance.fetchPosts { (posts) in
            PostController.sharedInstance.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

}
extension PostListTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text?.lowercased(), !searchText.isEmpty else {return}
        var arrayOfSearchResults = [Post]()
        for post in resultsArray{
            if post.matches(searchTerm: searchText){
                arrayOfSearchResults.append(post)
            }
        }
        resultsArray = arrayOfSearchResults
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        tableView.resignFirstResponder()
        resultsArray = PostController.sharedInstance.posts
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
