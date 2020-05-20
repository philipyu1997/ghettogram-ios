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
import MessageInputBar

class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var posts = [PFObject]()
    private var selectedPost: PFObject!
    private var numberOfPost: Int!
    private var refreshControl: UIRefreshControl!
    private var showsCommentBar = false
    
    private let feedLimit = 20
    private let commentBar = MessageInputBar()
    
    override var inputAccessoryView: UIView? {
        
        return commentBar
        
    }
    
    override var canBecomeFirstResponder: Bool {
        
        return showsCommentBar
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize comment bar
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        // Set table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPost), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        numberOfPost = 5
        loadPost()
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
        
    }
    
    // MARK: - Private Function Section
    
    // Load first posts
    @objc private func loadPost() {
        
        let query = PFQuery(className: "Posts")
        
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = numberOfPost
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print("Error: \(String(describing: error))")
            }
        }
        
    }
    
    // Load more posts
    private func loadMorePost() {
        
        self.numberOfPost += 5
        self.loadPost()
        
    }
    
    // Call the delay method in your onRefresh() method
    @objc private func onRefresh() {
        
        run(after: 2) {
            self.refreshControl.endRefreshing()
        }
        
    }
    
    // Implement the delay method
    private func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        
        let queue = DispatchQueue.main
        
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
        
    }
    
    @objc private func keyboardWillBeHidden(note: Notification) {
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        
        becomeFirstResponder()
        
    }
    
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        let profileImage = PFUser.current()!["image"] as? PFFileObject
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postImageView.af.setImage(withURL: url)
            
            profileImage?.getDataInBackground(block: { (success, error) in
                if success != nil, error == nil {
                    let image = UIImage(data: success!)
                    cell.userImageView.image = image
                } else {
                    print("Error: \(String(describing: error))")
                }
            })
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            
            profileImage?.getDataInBackground(block: { (success, error) in
                if success != nil, error == nil {
                    let image = UIImage(data: success!)
                    cell.userImageView.image = image
                } else {
                    print("Error: \(String(describing: error))")
                }
            })
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if posts.count < numberOfPost {
            if indexPath.row + 1 == posts.count {
                loadMorePost()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
        
    }
    
}

extension FeedViewController: MessageInputBarDelegate {
    
    // MARK: - MessageInputBarDelegate Section
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Create the comment
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("SUCCESS: Successfully commented on a photo!")
            } else {
                print("Error: \(String(describing: error))")
            }
        }
        
        tableView.reloadData()
        
        // Clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        
    }
    
}
