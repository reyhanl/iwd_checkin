//
//  LogViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 05/06/24.
//

import UIKit

class LogViewController: UIViewController{
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LogTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.accessibilityIdentifier = "tableView"
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var logs: [Log] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Logs"
        navigationController?.navigationBar.prefersLargeTitles = true
        addTableView()
        fetchLogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLogs()
    }
    
    func addTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func fetchLogs(){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)

        do{
            let logs: [Log] = try helper.fetchItemsToGeneric(entity: .log, with: nil)
            self.logs = logs
            tableView.reloadData()
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
}

extension LogViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogTableViewCell
        cell.setupCell(log: logs[indexPath.row])
        return cell
    }
}

extension Notification.Name {
    static let changeData = Notification.Name("changeDataNotification")
}
