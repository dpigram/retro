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
    var retroDescription: String
    var items: Int
    
    init(title: String, teamId: Any, retroId: Any, retroDescription: String, numberOfItems: Any) {
        self.title = title
        self.teamId = teamId as! Int
        self.retroId = retroId as! Int
        self.retroDescription = retroDescription
        self.items = numberOfItems as! Int
    }
    
    override var description: String {
        return self.title
    }
}
