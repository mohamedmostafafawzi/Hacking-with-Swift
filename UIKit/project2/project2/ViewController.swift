//
//  ViewController.swift
//  project2
//
//  Created by Mohamed Fawzi on 5/28/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsCount = 0
    var alertMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScoreTapped))
        
    }


    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsCount += 1
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title =  "Country: \(countries[correctAnswer].uppercased()) | Score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String?
        
        if sender.tag == correctAnswer {
            title =  "Correct!"
            score += 1
            alertMessage = """
Score: \(score)
Question Left: \(10 - questionsCount)
"""
        } else {
            title = "Wrong!"
            score -= 1
            alertMessage = """
That's the Flag of \(countries[sender.tag].uppercased())
Score: \(score)
Question Left: \(10 - questionsCount)
"""
        }
        
        if questionsCount < 10 {

            showAlert(title: title, message: alertMessage, actionTitle: "Continue")
        } else {
            showAlert(title: title, message: alertMessage, actionTitle: "Restart")
            questionsCount = 0
            score = 0
        }
        
    }
    
    func showAlert(title: String?, message: String, actionTitle: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func showScoreTapped() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
}

