//
//  ViewController.swift
//  project5
//
//  Created by Mohamed Fawzi on 6/5/22.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(restartGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
    }

    func startGame() {
        let defaults = UserDefaults.standard

        if let previousWord = defaults.string(forKey: "word"), previousWord != "" {
            title = previousWord
        } else {
            title = allWords.randomElement()
        }
        usedWords = defaults.object(forKey: "usedWords") as? [String] ?? [String]()
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
        }
        let defaults = UserDefaults.standard

        defaults.set(title, forKey: "word")
        defaults.set(usedWords, forKey: "usedWords")
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        guard !usedWords.contains(word) else { return false }
        guard word != title?.lowercased() else {
            showErrorMessage(errorTitle: "Answer is the starting word", errorMessage: "Answer can't be the starting word itself")
            return false
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        guard word.utf16.count >= 3 else {
            showErrorMessage(errorTitle: "Invalid Answer", errorMessage: "Answer is less than 3 letters")
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let missspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return missspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
}

