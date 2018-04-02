//
//  TeamDetailViewController.swift
//  MetroRetro
//
//  Created by Derell Pigram on 9/10/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var team: MRTeam?
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let reuseIdentifier = "RetroCell"
    
    var data: [MRRetro]?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(notification:)), name: Notification.Name("teamSelected"), object: nil)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let cellNib = UINib(nibName: "RetrospcectiveCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    func loadData(notification: Notification) -> Void {
        if let team = notification.object {
            self.team = team as? MRTeam
            if let team = self.team {
                self.label.text = team.name
                self.descriptionTextView.text = team.desc
                
                let logInServices: LoginServices = LoginServices.shareInstance() as! LoginServices
                
                logInServices.requestRetros(forTeam: team.teamId, completionHandler: { (retros: [MRRetro]?, error: Error?) in
                    if let arrRetros = retros {
                        self.data = arrRetros
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    func updateLabel(notification: Notification) -> Void {
        if let name = notification.object {
            
            self.label.text = name as? String
        }
    }
    
    @IBAction func newRetroTapped(_ sender: Any) {
        print("newRetroTapped")
    }
}

// MARK: - UICollectionViewDataSource
extension TeamDetailViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("got here")
        guard let theData = data, !theData.isEmpty else {
            return 0
        }
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! RetrospcectiveCollectionViewCell
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension TeamDetailViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TeamDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
