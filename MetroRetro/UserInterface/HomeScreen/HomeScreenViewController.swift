//
//  HomeScreenViewController.swift
//  MetroRetro
//
//  Created by Derell Pigram on 9/10/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

@objc class HomeScreenViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let logInVC: LoginViewController  = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(logInVC, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

}
