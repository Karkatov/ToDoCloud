

import UIKit

class DetailWeatherVC: UIViewController {
    
    let weatherViewController = WeatherViewController()
    let tableView = UITableView()
    var detail = [String]()
    var currentWeather: CurrentWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        tableView.animateTableView()
    }
    
    private func setTableView() {
        tableView.isScrollEnabled = false
        self.view.backgroundColor = .myGray()
        tableView.backgroundColor = .darkWhite()
        let nameCity = detail.removeFirst().uppercased()
        navigationItem.title = "\(nameCity)"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        tableView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height / 2.26)
        tableView.layer.cornerRadius = 20
        view.addSubview(tableView)
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource 
extension DetailWeatherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = detail[indexPath.row]
        myCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

