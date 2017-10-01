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
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var team: MRTeam?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(notification:)), name: Notification.Name("teamSelected"), object: nil)

    }
    
    
    func loadData(notification: Notification) -> Void {
        if let team = notification.object {
            self.team = team as? MRTeam
            if let team = self.team {
                self.label.text = team.name
                self.descriptionTextView.text = team.desc
            }
            
        }
    }
    func updateLabel(notification: Notification) -> Void {
        if let name = notification.object {
            
            self.label.text = name as? String
        }
    }
}
