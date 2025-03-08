//
//  WelcomeViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 04/06/24.
//

import UIKit

class WelcomeViewController: UIViewController{
    
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var textField: CustomTextField = {
        let textField = CustomTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Sheet id"
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .systemFill
        textField.text = "iwd2025GridView"
//        textField.delegate = self
        textField.shouldValidate = true
        textField.validation = [.minimumNumberOfLetter(6)]
        textField.addTarget(target: self, selector: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    lazy var button: CustomButton = {
        let button = CustomButton(frame: .zero, backgroundColor: .primaryButton, pressedColor: .primaryButtonPressed)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.layer.cornerRadius = 5
//        button.isEnabled = false
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    lazy var loadingView: LoadingView = {
        let view = LoadingView(duration: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var isLoading = false{
        didSet{
            button.isEnabled = !isLoading
            loadingView.isHidden = !isLoading
            if isLoading{
                DispatchQueue.global(qos: .background).sync(execute: {
                    self.loadingView.startLoading()
                })
            }else{
                loadingView.stopLoading()
            }
        }
    }
    var backgroundType: BackgroundName = .bnw
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addBackgroundView()
        addContainerView()
        addImageView()
        addTextField()
        addButton()
        addLoadingView()
        backgroundView.image = UIImage(named: backgroundType.rotatingBackgroundName)
        imageView.image = UIImage(named: backgroundType.onBoardingImage)
    }
    
    
    func addBackgroundView(){
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 2, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 2, constant: 0),
        ])
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        containerView.frame.origin.y = -keyboardHeight
    }


   @objc func keyBoardWillHide(notification: NSNotification) {
       containerView.frame.origin.y = 0
    }
    
    func addContainerView(){
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        ])
    }
    
    func addImageView(){
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
    }
    
    func addTextField(){
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        ])
    }
    
    func addButton(){
        containerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: textField, attribute: .width, multiplier: 0.3, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addLoadingView(){
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.3, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.3, constant: 0)
        ])
    }
    
    @objc func tapButton(){
        guard let id = textField.text else{return}
//        isLoading = true
        UserDefaults.standard.setValue(id, forKey: UserDefaultKey.tempSheetID.rawValue)
        self.fetchData(id: id)
    }
    
    func fetchData(id: String){
        let tempAttendes: [Attende] = []
        DispatchQueue.global(qos: .background).async {
            
            NetworkManager.shared.request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getAttendes(id).url, queryItems: []) { (result: Result<[Attende], Error>) in
                switch result {
                case .success(let resp):
                    let resp = resp.sorted(by: {$0.email < $1.email})
                    self.storeToCoreData(attendes: resp)
                    self.containerView.isHidden = true
                    self.presentVC(attendes: resp, id: id)
                    self.saveToUserDefault(sheetID: id)
//                    self.presentVC(attendes: MockDataProvider.generateAttendes(), id: id)
                    break
                case .failure(let failure):
                    break
                }
                self.isLoading = false
            }
        }
    }
    
    func saveToUserDefault(sheetID: String){
        UserDefaults.standard.setValue(sheetID, forKey: UserDefaultKey.sheetID.rawValue)
    }
    
    func storeToCoreData(attendes: [Attende]){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            for attende in attendes{
                try helper.saveNewData(entity: .attende, object: attende)
            }
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    func presentVC(attendes: [Attende], id: String){
        print(attendes.count)
        let vc = HomeRouter.makeComponent(data: attendes, sheetID: id)
        let navigationController = CustomNavigationController(rootViewController: vc)
        let homeTabBarItem = UITabBarItem(title: "QR", image: UIImage.init(systemName: "qrcode"), selectedImage: UIImage.init(systemName: "qrcode"))
        let logTabBarItem = UITabBarItem(title: "Logs", image: UIImage.init(systemName: "clock"), selectedImage: UIImage.init(systemName: "clock.fill"))
        let settingTabBarItem = UITabBarItem(title: "Setting", image: UIImage.init(systemName: "gear"), selectedImage: UIImage.init(systemName: "gear.circle.fill"))
        vc.tabBarItem = homeTabBarItem
        vc.backgroundType = backgroundType
        
        let settingVC = SettingViewController()
        let settingNavigationController = CustomNavigationController(rootViewController: settingVC)
        settingVC.tabBarItem = settingTabBarItem
        settingVC.selectedBackground = backgroundType
        
        let logVC = LogViewController()
        let logNavigationController = CustomNavigationController(rootViewController: logVC)
        logVC.tabBarItem = logTabBarItem
        
        let tabBar = CustomTabBarController()
        tabBar.tabBar.isOpaque = true
        tabBar.addChild(navigationController)
        tabBar.addChild(logNavigationController)
        tabBar.addChild(settingNavigationController)
        
        self.transitioningDelegate = tabBar.customTransitionDelegate
        tabBar.transitioningDelegate = tabBar.customTransitionDelegate
        tabBar.customTransitionDelegate.presentationTransitionType = .loading(backgroundView)
        tabBar.customTransitionDelegate.dismissalTransitionType = .none
        tabBar.modalPresentationStyle = .custom
        

        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    @objc func textDidChange(_: UITextField){
        button.isEnabled = textField.status == .valid
    }
}

enum UserDefaultKey: String{
    case sheetID = "sheetID"
    case tempSheetID = "tempSheetID"
    case background = "background"
}
