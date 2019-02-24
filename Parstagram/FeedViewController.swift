//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Rodrigo Leyva on 2/14/19.
//  Copyright © 2019 Rodrigo Leyva. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
class FeedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var posts = [PFObject]()

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(withIdentifier: "LogInViewController")
        
        let delagate = UIApplication.shared.delegate as! AppDelegate
        
        delagate.window?.rootViewController = loginViewController
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                
            }else{
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell") as! PostCell
        
        
        let post = posts[indexPath.row]
        
        
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        
        cell.commentLabel.text = post["caption"] as! String
        
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.pictureVIew.af_setImage(withURL: url)
        
        
        
        
        return cell
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
