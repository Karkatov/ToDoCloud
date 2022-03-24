//
//  SecondViewController.swift
//  Weather App
//
//  Created by Duxxless on 27.01.2022.
//

import UIKit

class DetailWeatherVC: UIViewController {

    let weatherViewController = WeatherVC()
    let tableView = UITableView()
    var detail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemMint
        tableView.backgroundColor = .systemBlue
        let nameCity = detail.removeFirst()
        navigationItem.title = "\(nameCity)"
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        tableView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height)
        tableView.layer.cornerRadius = 20
        view.addSubview(tableView)
        tableView.animateTableView()
    }
}

extension DetailWeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = detail[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

