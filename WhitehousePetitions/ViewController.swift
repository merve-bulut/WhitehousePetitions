//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Merve Bulut on 25.08.2026.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var mainPetitions = [Petition]()
    var filterPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterData))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterData() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else { return }
            self?.filter(word)
        }
        
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    func filter(_ word: String) {
        petitions = mainPetitions
        let lowerWord = word.lowercased()
        
        let filteredPetitions = petitions.filter {$0.title.localizedCaseInsensitiveContains(lowerWord)}
        
        petitions = filteredPetitions
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetition.results
            tableView.reloadData()
        }
        
        mainPetitions = petitions
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

