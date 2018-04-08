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
        self.tableView.backgroundColor = UIColor(red: 59.0/255, green: 65.0/255, blue: 78.0/255, alpha: 1)
        let cellNib = UINib(nibName: "TeamListTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "TeamListTableViewCell")
        self.title = "Teams"
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Data");
        refresher.addTarget(self, action: #selector(self.loadData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        self.tableView.tableFooterView = UIView()
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
        let team = self.teams[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListTableViewCell", for: indexPath) as! TeamListTableViewCell
        cell.name.text = team.name
        cell.teamDescription.text = team.desc
//        cell.textLabel?.text = self.teams[indexPath.row].name
//        cell.textLabel?.textColor = UIColor.white
//        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.teams[indexPath.row].name + "selected")
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "teamSelected"), object: self.teams[indexPath.row]))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func loadData() {
        self.service.requestTeam(forUser: 3) { (teams: [MRTeam]?, error: Error?) in
            if let array = teams {
                self.teams = array
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let logInVC: LoginViewController  = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        logInVC.modalTransitionStyle = .crossDissolve
        self.present(logInVC, animated: true, completion: nil)
    }
    
}
