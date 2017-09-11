//
//  TeamsListViewController.swift
//  MetroRetro
//
//  Created by Derell Pigram on 9/10/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

protocol TeamListDelegate {
    func didSelectTeam(teamName: String) -> (Void)
}

class TeamsListViewController: UITableViewController {

    var teamNames: [String] = []
    var delegate: TeamListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Teams"
        self.teamNames = ["Mothership","Tactical","LollyPod"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamNames.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.teamNames[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.teamNames[indexPath.row] + "selected")
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "teamSelected"), object: self.teamNames[indexPath.row]))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
