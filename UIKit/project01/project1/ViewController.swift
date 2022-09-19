//
//  ViewController.swift
//  project1
//
//  Created by Mohamed Fawzi on 5/27/22.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var viewCount = [String: Int]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture
                    self?.pictures.append(item)
                }
                self?.pictures.sort()
                    
            }
        }
        viewCount = defaults.object(forKey: "views") as? [String: Int] ?? [String: Int]()
        
        print(pictures)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        defaults.set(viewCount, forKey: "views")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "\(viewCount[pictures[indexPath.row]] ?? 0) Views"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.images = pictures
            vc.selectedRow = indexPath.row
            if let views = viewCount[pictures[indexPath.row]] {
                viewCount[pictures[indexPath.row]] = views + 1
            }
            self.tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

