//
//  MRRetro.swift
//  MetroRetro
//
//  Created by Derell Pigram on 11/12/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

@objc class MRRetro: NSObject {
    var title: String
    var teamId: Int
    var retroId: Int
    
    init(title: String, teamId: Int, retroId: Int) {
        self.title = title
        self.teamId = teamId
        self.retroId = retroId
    }
    
    override var description: String {
        return self.title
    }
}
