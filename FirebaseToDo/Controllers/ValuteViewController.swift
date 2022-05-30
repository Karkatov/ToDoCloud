//
//  ViewController.swift
//  СurrencyRate
//
//  Created by Duxxless on 25.02.2022.
//

import UIKit

class ValuteViewController: UIViewController {
    
    let refresh = UIRefreshControl()
    let tableView = UITableView()
    let networkRateManager = NetworkRateManager()
    var valutes: [[String]] = []
    var sortIndex = "<"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setView()
        setTableView()
        setRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    private func setView() {
        let backgroundColor = UIColor(red: 25/255,  green: 75/255, blue: 109/255, alpha: 1)
        let myView = UIView()
        myView.backgroundColor = .myGray()
        myView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(myView)
        self.view.backgroundColor = backgroundColor
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font : setMyFont(24)]
        navigationItem.title = "Kурс рубля"
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortValue))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setTableView() {
        tableView.register(CustomValuteCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        if UIScreen.main.bounds.size.height < 670 {
            tableView.frame = CGRect(x: 20, y: 70, width: view.frame.size.width - 40,
                                     height: view.frame.size.height - 150)
        } else {
            tableView.frame = CGRect(x: 15, y: 100, width: view.frame.size.width - 30,
                                     height: view.frame.size.height - 210)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        view.addSubview(tableView)
    }
    
    func setRefresh() {
        tableView.refreshControl = refresh
        refresh.tintColor = .systemGray4
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
            self.valutes.sort { $0[2] > $1[2] }
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
    func setMyFont(_ size: Double) -> UIFont {
        let font = UIFont(name: "Gill Sans", size: size)
        return font!
    }
}

extension ValuteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomValuteCell
        
        let object = valutes[indexPath.row]
        cell.setCell(object: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.2) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}



