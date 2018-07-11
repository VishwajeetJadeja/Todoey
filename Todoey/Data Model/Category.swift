//
//  Category.swift
//  Todoey
//
//  Created by vishwajeet on 08/07/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
