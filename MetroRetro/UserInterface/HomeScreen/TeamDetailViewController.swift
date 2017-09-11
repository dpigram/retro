//
//  TeamDetailViewController.swift
//  MetroRetro
//
//  Created by Derell Pigram on 9/10/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabel(notification:)), name: Notification.Name("teamSelected"), object: nil)

    }
    
    func updateLabel(notification: Notification) -> Void {
        if let name = notification.object {
            self.label.text = name as? String
        }
    }
}
