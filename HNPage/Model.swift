//
//  Model.swift
//  HNPage
//
//  Created by hainuo on 2022/1/12.
//

import Foundation
import HandyJSON

struct TTNRType: HandyJSON {
    var name = ""
    var id: Int!
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }

    init() {}
}


