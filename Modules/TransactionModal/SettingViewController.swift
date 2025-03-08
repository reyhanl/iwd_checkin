//
//  SettingViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 05/06/24.
//

import UIKit

class SettingViewController: UIViewController{
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "tableView"
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var backgroundTypes: [BackgroundName] = [.bnw, .color]
    var settings: [Setting] = [.changeSheet, .deleteLogs]
    var selectedBackground: BackgroundName = .bnw
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        addCollectionView()
        addTableView()
    }
    
    func addCollectionView(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: (view.frame.width) / 2)
        ])
    }
    
    func addTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func presentConfirmationAlert(setting: Setting){
//        let alert = UIAlertController()
//        alert.title = setting.alertTitle
//        alert.addAction(.init(title: "Continue", style: .destructive, handler: { action in
//            switch setting {
//            case .deleteLogs:
//                self.deleteLocalData()
//            case .changeSheet:
//                self.changeSheet()
//                NotificationCenter.default.post(name: .changeData, object: nil)
//            }
//        }))
//        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { action in
//            alert.dismiss(animated: true)
//        }))
//        self.present(alert, animated: true)
        let customAlert = CustomAlertViewController(image: setting.image, title: "Are you sure want to delete")
        customAlert.addAction(action: .init(title: "Cancel", action: {
            customAlert.dismiss(animated: true)
        }, color: .cancelButtonColor, textColor: .cancelButtonTextColor))
        customAlert.addAction(action: .init(title: "Yes, I am sure", action: {
            switch setting{
            case .changeSheet:
                self.changeSheet()
                NotificationCenter.default.post(name: .changeData, object: nil)
            case .deleteLogs:
                self.deleteLocalData()
                customAlert.dismiss(animated: true)
            }
        }, color: setting.color))
        customAlert.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(customAlert, animated: true)
    }
    
    func deleteLocalData(){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            try helper.deleteAllRecords(entity: .log)
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    func changeSheet(){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            UserDefaults.standard.setValue(nil, forKey: UserDefaultKey.sheetID.rawValue)
            try helper.deleteAllRecords(entity: .log)
            try helper.deleteAllRecords(entity: .attende)
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        cell.setupCell(setting: settings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentConfirmationAlert(setting: settings[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
}

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BackgroundCollectionViewCell
        cell.setupCell(background: backgroundTypes[indexPath.row], isSelected: backgroundTypes[indexPath.row] == selectedBackground)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 30) / 2
        return .init(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(backgroundTypes[indexPath.row].rawValue, forKey: UserDefaultKey.background.rawValue)
        selectedBackground = backgroundTypes[indexPath.row]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.reuseIdentifier, for: indexPath) as! CustomHeaderView
            header.configure(with: "Style")
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

enum Setting: String{
    case deleteLogs = "Delete logs"
    case changeSheet = "Change data"
    
    var icon: String{
        switch self{
        case .changeSheet:
            return "📝"
        case .deleteLogs:
            return "🗑️"
        }
    }
    
    var alertTitle: String{
        switch self{
        case .changeSheet:
            return "Are you sure you want to change sheet? \n your local copy of the data is going to be deleted"
        case .deleteLogs:
            return "Are you sure you want to delete logs? \n your local copy of the data is going to be deleted"
        }
    }
    
    var image: UIImage?{
        switch self{
        case .changeSheet:
            return UIImage(named: "changeSheet")
        case .deleteLogs:
            return UIImage(named: "trash")
        }
    }
    
    var color: UIColor{
        switch self{
        case .changeSheet:
            return UIColor.init(hex: "97375A")
        case .deleteLogs:
            return UIColor.init(hex: "97375A")
        }
    }
}
