//
//  Person.swift
//  project10
//
//  Created by Mohamed Fawzi on 7/30/22.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
