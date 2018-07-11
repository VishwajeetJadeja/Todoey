//
//  Item.swift
//  Todoey
//
//  Created by vishwajeet on 08/07/18.
//  Copyright © 2018 vishwajeet jadeja. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
   
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
