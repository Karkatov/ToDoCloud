//
//  ViewController.swift
//  СurrencyRate
//
//  Created by Duxxless on 25.02.2022.
//

import UIKit

class ViewControllerValute: UIViewController {
    
    let refresh = UIRefreshControl()
    let tableViewController = UITableViewController()
    let networkRateManager = NetworkRateManager()
    var valutes: [[String]] = []
    
    var sortIndex = "<"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.view.backgroundColor = UIColor(red: 0/255, green: 36/255, blue: 67/255, alpha: 1)
        tableViewController.tableView.backgroundColor = UIColor(red: 0/255, green: 36/255, blue: 67/255, alpha: 1)
        setTableView()
        setRefresh()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        tableViewController.tableView.frame = CGRect(x: 0, y: 91, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPath = tableViewController.tableView.indexPathForSelectedRow {
            tableViewController.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setTableView() {
        
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Kурс валют"
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortValue))
        navigationItem.rightBarButtonItem = sortButton
        
        tableViewController.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableViewController.tableView.frame = view.frame
        tableViewController.tableView.delegate = self
        tableViewController.tableView.dataSource = self
        view.addSubview(tableViewController.tableView)
    }
    
    func setRefresh() {
        tableViewController.tableView.refreshControl = refresh
        refresh.tintColor = .red
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    @objc func refreshTableView() {
        
        self.refresh.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.fetchData()
        }
    }
    func fetchData() {
        networkRateManager.fetchCurrencyRate { data in
            self.valutes = data
            self.tableViewController.tableView.reloadData()
        }
    }
    
    @objc func sortValue() {
        if sortIndex == "<" {
        valutes.sort { $0[2] < $1[2] }
            sortIndex = ">"
            print()
        } else {
            valutes.sort { $0[2] > $1[2] }
            sortIndex = "<"
        }
        tableViewController.tableView.reloadData()
    }
}

extension ViewControllerValute: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valutes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let object = valutes[indexPath.row]
        cell.setCell(object: object)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



