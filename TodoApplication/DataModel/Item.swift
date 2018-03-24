//
//  Item.swift
//  TodoApplication
//
//  Created by Abhishek Dewan on 3/22/18.
//  Copyright © 2018 Abhishek Dewan. All rights reserved.
//

import Foundation

class Item : Encodable,Decodable{
    var title = ""
    var done = false
    
    init(title:String,done:Bool) {
        self.title = title
        self.done = done
    }
}
