//
//  NewPostViewController.swift
//  VoteSJSU
//
//  Created by Personal on 5/7/18.
//  Copyright © 2018 San Jose State University. All rights reserved.
//

import UIKit
import GoogleSignIn

class NewPostViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var typeToggle: UISegmentedControl!
    @IBOutlet weak var anonToggle: UISegmentedControl!
    @IBOutlet weak var choice1Field: UITextField!
    @IBOutlet weak var choice2Field: UITextField!
    @IBOutlet weak var choice3Field: UITextField!
    @IBOutlet weak var choice4Field: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setChoiceFieldsEnabled()
    }

    @IBAction func typeChanged(_ sender: Any) {
        setChoiceFieldsEnabled()
    }
    
    func setChoiceFieldsEnabled() {
        if typeToggle.selectedSegmentIndex == 0 {
            // it's a rating, so diable choice boxes
            choice1Field.isEnabled = false
            choice2Field.isEnabled = false
            choice3Field.isEnabled = false
            choice4Field.isEnabled = false
        } else {
            // it's a poll, re-enable choice boxes
            choice1Field.isEnabled = true
            choice2Field.isEnabled = true
            choice3Field.isEnabled = true
            choice4Field.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowNewPost":
            print(GIDSignIn.sharedInstance().currentUser.profile.email!)
            print("Anon toggle:", anonToggle.selectedSegmentIndex, "Type toggle:", typeToggle.selectedSegmentIndex)
            let postBody : [String : String]
            if typeToggle.selectedSegmentIndex == 0 {
                // it's a rating
                postBody = [
                    "title": titleField.text!,
                    "author": anonToggle.selectedSegmentIndex == 0 ? "" : String(GIDSignIn.sharedInstance().currentUser.profile.email!),
                    "post_type": "rating",
                ]
            } else {
                // it's a poll
                postBody = [
                    "title": titleField.text!,
                    "author": anonToggle.selectedSegmentIndex == 0 ? "" : String(GIDSignIn.sharedInstance().currentUser.profile.email!),
                    "post_type": typeToggle.selectedSegmentIndex == 0 ? "rating" : "poll",
                    "choice1": choice1Field.text!,
                    "choice2": choice2Field.text!,
                    "choice3": choice3Field.text!,
                    "choice4": choice4Field.text!,
                ]
            }
            print("Posting", postBody)
            let postResult = APIClient.post(endpoint: Constants.POST_ENDPOINT, body: postBody)
            if postResult.rc != 201 {
                print("Failed to create new post")
                return
            }
            guard let postViewController = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let newPost = postResult.data! as! [String: Any]
            let choice1 = newPost["choice1"] as? String ?? ""
            let choice2 = newPost["choice2"] as? String ?? ""
            let choice3 = newPost["choice3"] as? String ?? ""
            let choice4 = newPost["choice4"] as? String ?? ""
            if let title = newPost["title"] as? String,
                let id = newPost["post_id"] as? Int,
                let type = newPost["post_type"] as? String,
                let url = newPost["url"] as? String,
                let rating = newPost["rating"] as? NSString,
                let numRatings = newPost["num_ratings"] as? Int,
                let choice1Votes = newPost["choice1_votes"] as? Int,
                let choice2Votes = newPost["choice2_votes"] as? Int,
                let choice3Votes = newPost["choice3_votes"] as? Int,
                let choice4Votes = newPost["choice4_votes"] as? Int,
                let postDate = newPost["post_date"] as? String,
                let author = newPost["author"] as? String? ?? "Anonymous"
            {
                postViewController.post = Post(
                    id: id,
                    title: title,
                    post_type: type,
                    url: url,
                    choice1: choice1,
                    choice2: choice2,
                    choice3: choice3,
                    choice4: choice4,
                    rating: rating.floatValue,
                    num_ratings: numRatings,
                    choice1_votes: choice1Votes,
                    choice2_votes: choice2Votes,
                    choice3_votes: choice3Votes,
                    choice4_votes: choice4Votes,
                    post_date: String(postDate[..<(postDate.index(of: "T"))!]),
                    author: author
                )
                print("Created post with id =", id)
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
