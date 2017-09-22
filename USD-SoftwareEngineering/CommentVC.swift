//
//  CommentVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommentVC: UIViewController{
    
    var presentingVC: UIViewController!
    var firebaseUser: User!
    var user: UserData!
    var ideaReference: String!
    
    override func viewDidLoad() {
        firebaseUser = Auth.auth().currentUser!
        DataService.singleton.observeUser(uid: firebaseUser.uid, completed: { (user) in
            self.user = user
        })
    }
    
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let commentData = IdeaCommentData(ideaCommentAuthorName: user.name, ideaCommentAuthorUID: user.userUID, ideaCommentText: commentTextView.text!, timestamp: Date().timeIntervalSince1970)
        DataService.singleton.submitComment(ideaReference: ideaReference, comment: commentData)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Close
    override func viewWillDisappear(_ animated: Bool) {
        removeView()
    }
    
    func removeView(){
        for subview in self.presentingVC.view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }

    
}
