//
//  ViewController.swift
//  project1
//
//  Created by Mohamed Fawzi on 5/27/22.
//

import UIKit

class ViewController: UIViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture
                pictures.append(item)
            }
                
        }
        
        print(pictures)
        
    }


}

