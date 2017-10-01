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

    var teams: [MRTeam] = []
    var delegate: TeamListDelegate?
    var refresher = UIRefreshControl()
    let service: LoginServices = LoginServices.shareInstance() as! LoginServices
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Teams"
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Data");
        refresher.addTarget(self, action: #selector(self.loadData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.teams[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.teams[indexPath.row].name + "selected")
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "teamSelected"), object: self.teams[indexPath.row]))
    }
    
    
    func loadData() {
        self.service.requestTeam(forUser: 3) { (teams: [MRTeam]?, error: Error?) in
            if let array = teams {
                self.teams = array
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
