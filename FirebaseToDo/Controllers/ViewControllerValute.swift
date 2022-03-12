//
//  ViewController.swift
//  СurrencyRate
//
//  Created by Duxxless on 25.02.2022.
//

import UIKit

class ViewControllerValute: UIViewController {
    
    let refresh = UIRefreshControl()
    let tableView = UITableView()
    let networkRateManager = NetworkRateManager()
    var valutes: [[String]] = []
    
    var sortIndex = "<"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setTableView()
        setRefresh()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setTableView() {
        
        let backgroundColor = UIColor(red: 25/255,
                                      green: 75/255,
                                      blue: 109/255,
                                      alpha: 1)
        
        self.view.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Kурс рубля"
        navigationController?.navigationBar.barTintColor  = backgroundColor
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortValue))
        navigationItem.rightBarButtonItem = sortButton
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.frame = CGRect(x: 0,
                                                     y: 85,
                                                     width: view.frame.size.width,
                                                     height: view.frame.size.height - 175)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    func setRefresh() {
        tableView.refreshControl = refresh
        refresh.tintColor = .white
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
            self.tableView.reloadData()
        }
    }
    
    @objc func sortValue() {
        if sortIndex == "<" {
        valutes.sort { $0[2] < $1[2] }
            sortIndex = ">"
        } else {
            valutes.sort { $0[2] > $1[2] }
            sortIndex = "<"
        }
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.55) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}



