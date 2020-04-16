//
//  HomeViewController.swift
//  iFridge
//
//  Created by Shivani Mehan on 2020-04-16.
//  Copyright © 2020 CP469-ShivaniAndJacob. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var menuShowing = false

    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBackgroundImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openMenu(_ sender: Any) {
        if (menuShowing){
            menuLeadingConstraint.constant = -205
            menuBackgroundImageLeadingConstraint.constant = -205
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                           self.view.layoutIfNeeded()
            })
        } else {
            menu.isHidden = false
            menuLeadingConstraint.constant = 0
            menuBackgroundImageLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToStart", sender: self)

    }
}
