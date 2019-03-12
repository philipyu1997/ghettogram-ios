//
//  FeedViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    var posts = [PFObject]()
    var numberOfPost: Int!
    var refreshControl: UIRefreshControl!
    let feedLimit = 20
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPost), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    } // end viewDidLoad function
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        numberOfPost = 5
        loadPost()
        
    } // end viewDidAppear function
    
    @objc func loadPost() {
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberOfPost
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print("Oh No! We can't fetch any photos!: \(error)")
            }
        }
        
    } // end loadPost function
    
    func loadMorePost() {
        
        numberOfPost += 5

        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberOfPost
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Oh No! We can't fetch any photos!: \(error)")
            }
        }
        
    } // end loadMorePost function
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if posts.count < feedLimit {
            if indexPath.row + 1 == posts.count {
                loadMorePost()
            }
//        } else {
//            print("Feed limit reached")
        }
        
    } // end tableView(willDisplay) function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    } // end tableView(numberOfRowsInSection) function
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
        
    } // end tableView(cellForRowAt) function
    
    // Call the delay method in your onRefresh() method
    @objc func onRefresh() {
        
        run(after: 2) {
            self.refreshControl.endRefreshing()
        }
        
    } // end onRefresh function
    
    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
        
    } // end run function
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
        
    } // end onLogoutButton function
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // end FeedViewController class
