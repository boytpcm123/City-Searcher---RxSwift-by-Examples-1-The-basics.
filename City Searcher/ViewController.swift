//
//  ViewController.swift
//  City Searcher
//
//  Created by ninjaKID on 5/24/18.
//  Copyright © 2018 ninjaKID. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var showCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // Filter for non-empty query
            .subscribe(onNext: { [weak self] value in // Here we subscribe to every new value
                self?.showCities = (self?.allCities.filter{ $0.hasPrefix(value) })! // We now do our "API Request" to find cities
                self?.tableView.reloadData() // And reload table view data
            })
            .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = showCities[indexPath.row]
        
        return cell
    }

}

