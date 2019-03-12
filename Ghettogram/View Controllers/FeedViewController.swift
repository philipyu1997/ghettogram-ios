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

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageInputBarDelegate {
    
    // Properties
    var posts = [PFObject]()
    var profile = [PFObject]()
    var selectedPost: PFObject!
    var numberOfPost: Int!
    var refreshControl: UIRefreshControl!
    var showsCommentBar = false
    let feedLimit = 20
    let commentBar = MessageInputBar()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = numberOfPost
        query.order(byDescending: "createdAt")
        
        let profileQuery = PFQuery(className: "User")
        profileQuery.includeKey("image")
        
        profileQuery.findObjectsInBackground { (profile, error) in
            if profile != nil {
                self.profile = profile!
            }
        }
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print("Error: \(error)")
            }
        }
        
    } // end loadPost function
    
    func loadMorePost() {
        
        self.numberOfPost += 5
        self.loadPost()
        
    } // end loadMorePost function
    
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
                print("ERROR: Failed to comment on a photo!")
            }
        }
        
        tableView.reloadData()
        
        // Clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        
    } // end messageInputBar function
    
    @objc func keyboardWillBeHidden(note: Notification) {
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        
    } // end keyboardWillBeHidden function
    
    override var inputAccessoryView: UIView? {
        
        return commentBar
        
    } // end inputAccessoryView function
    
    override var canBecomeFirstResponder: Bool {
        
        return showsCommentBar
        
    } // end canBecomeFirstResponder function
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if posts.count < numberOfPost {
            if indexPath.row + 1 == posts.count {
                loadMorePost()
            }
        }
        
    } // end tableView(willDisplay) function
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
        
    } // end numberOfSections function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
        
    } // end tableView(numberOfRowsInSection) function
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        let profiles = profile[0]
        
        let profileImageFile = profiles["image"] as! PFFileObject
        let profileUrlString = profileImageFile.url!
        let profileUrl = URL(string: profileUrlString)!

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postImageView.af_setImage(withURL: url)
            
            if profiles["image"] != nil {
                cell.userImageView.af_setImage(withURL: profileUrl)
            } else {
                print("ERROR: Failed to fetch user profile image. Display stock image.")
            }
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            cell.profileImageView.af_setImage(withURL: profileUrl)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
    } // end tableView(cellForRowAt) function
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
        
    } // end tableView(didSelectRowAt) function
    
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
