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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var team: MRTeam?
    var activityIndicator: UIActivityIndicatorView?
    fileprivate let reuseIdentifier = "RetroCell"
    
    var data: [MRRetro]?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(notification:)), name: Notification.Name("teamSelected"), object: nil)
        setUpCollectoinViewLayout()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let cellNib = UINib(nibName: "RetrospcectiveCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
    }
    
    
    func rotated() {
        collectionView.reloadData()
    }
    
    func loadData(notification: Notification) -> Void {
        if let team = notification.object {
            activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray);
            activityIndicator?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            activityIndicator?.startAnimating()
            self.view.addSubview(activityIndicator!)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.alpha = 0
            }
            self.team = team as? MRTeam
            if let team = self.team {
                self.label.text = team.name
                
                let logInServices: LoginServices = LoginServices.shareInstance() as! LoginServices
                
                logInServices.requestRetros(forTeam: team.teamId, completionHandler: { (retros: [MRRetro]?, error: Error?) in
                    if let arrRetros = retros {
                        self.data = arrRetros
                        UIView.animate(withDuration: 0.5, animations: {
                            self.collectionView.alpha = 1
                        })
                        self.collectionView.reloadData()
                        self.activityIndicator?.stopAnimating()
                        self.activityIndicator?.isHidden = true
                        self.activityIndicator?.removeFromSuperview()
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
    
    func setUpCollectoinViewLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
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
        if let theData = data {
            let cellData = theData[indexPath.row]
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.5
            cell.title.text = cellData.title
            cell.retoDescription.text = cellData.retroDescription.isEmpty ? "No Description Provided" : cellData.retroDescription
            cell.numberOfItems.text = "\(cellData.items) Items"
        }
        
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
//        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 5), height: collectionView.frame.width/3.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
