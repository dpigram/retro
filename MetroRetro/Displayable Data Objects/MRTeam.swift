//
//  MRTeam.swift
//  MetroRetro
//
//  Created by Derell Pigram on 10/1/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

@objc class MRTeam: NSObject {
    var teamId: Int
    var name: String
    var ownerId: Int
    var desc: String
    
    init(teamId: Int, name: String, ownerId: Int, desc: String) {
        self.teamId = teamId
        self.name = name
        self.ownerId = ownerId
        self.desc = desc
    }
    
    override var description: String {
        return self.name
    }
}
