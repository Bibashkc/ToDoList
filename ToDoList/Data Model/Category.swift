//
//  Category.swift
//  ToDoList
//
//  Created by Bibash Kc on 4/17/18.
//  Copyright © 2018 Bibash Kc. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>() // Forward relationship 
}
