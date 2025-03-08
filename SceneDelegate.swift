//
//  SceneDelegate.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var windowScene: UIWindowScene?
    var launchArgument: LaunchArgument?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.windowScene = windowScene
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.clear
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
//        removeAll()
        addStateListener()
        var background: BackgroundName = BackgroundName.bnw
        if let backgroundString = UserDefaults.standard.value(forKey: UserDefaultKey.background.rawValue) as? String,
            let temp = BackgroundName(rawValue: backgroundString){
            background = temp
        }else{
            UserDefaults.standard.setValue(background.rawValue, forKey: UserDefaultKey.background.rawValue)
        }
        if let sheetID = UserDefaults.standard.value(forKey: UserDefaultKey.sheetID.rawValue) as? String{
            self.presentMainVC(sheetID: sheetID, type: background)
        }else{
            presentWelcomeVC(type: background)
        }
    }
    
    func addStateListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(presentWelcome), name: .changeData, object: nil)
    }
    
    @objc func presentWelcome(){
        var background: BackgroundName = BackgroundName.bnw
        if let backgroundString = UserDefaults.standard.value(forKey: UserDefaultKey.background.rawValue) as? String,
            let temp = BackgroundName(rawValue: backgroundString){
            background = temp
        }else{
            UserDefaults.standard.setValue(background.rawValue, forKey: UserDefaultKey.background.rawValue)
        }
        presentWelcomeVC(type: background)
    }
    
    func removeAll(){
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
    
    
    func presentWelcomeVC(type: BackgroundName){
        guard let windowScene = windowScene else{return}
        let vc = WelcomeViewController()
        let navigationController = CustomNavigationController(rootViewController: vc)
        vc.backgroundType = type
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        window?.makeKeyAndVisible()
    }
    
    func presentMainVC(sheetID: String, type: BackgroundName){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            let attendes: [Attende] = try helper.fetchItemsToGeneric(entity: .attende, with: nil)
            print(attendes.count)
            let vc = HomeRouter.makeComponent(data: attendes, sheetID: sheetID)
            let navigationController = CustomNavigationController(rootViewController: vc)
            let homeTabBarItem = UITabBarItem(title: "QR", image: UIImage.init(systemName: "qrcode"), selectedImage: UIImage.init(systemName: "qrcode"))
            let logTabBarItem = UITabBarItem(title: "Logs", image: UIImage.init(systemName: "clock"), selectedImage: UIImage.init(systemName: "clock.fill"))
            let settingTabBarItem = UITabBarItem(title: "Setting", image: UIImage.init(systemName: "gear"), selectedImage: UIImage.init(systemName: "gear.circle.fill"))
            vc.tabBarItem = homeTabBarItem
            vc.backgroundType = type
            
            let settingVC = SettingViewController()
            let settingNavigationController = CustomNavigationController(rootViewController: settingVC)
            settingVC.tabBarItem = settingTabBarItem
            settingVC.selectedBackground = type
            
            let logVC = LogViewController()
            let logNavigationController = CustomNavigationController(rootViewController: logVC)
            logVC.tabBarItem = logTabBarItem
            
            let tabBar = CustomTabBarController()
            tabBar.tabBar.isOpaque = true
            tabBar.addChild(navigationController)
            tabBar.addChild(logNavigationController)
            tabBar.addChild(settingNavigationController)
            guard let windowScene = windowScene else{return}
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = tabBar
            window?.makeKeyAndVisible()
        }catch{
            print("something went wrong \(error.localizedDescription)")
        }
    }
    
    func presentTransactionModal(){
        guard let windowScene = windowScene else{return}
        let vc = UIViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let transactionModalVC = TransactionModalVC()
        transactionModalVC.modalPresentationStyle = .overCurrentContext
        transactionModalVC.setupUI(transaction: 
                .init(bank: "FakeBank",
                      transactionID: "123456789",
                      merchant: "FakeMerchant",
                      transactionTotal: 2000,
                      date: ""), user: .init(balance: 1999))
        vc.present(transactionModalVC, animated: true)
    }
    
    func presentTransactionModalWithSuccess(){
        guard let windowScene = windowScene else{return}
        let vc = UIViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let transactionModalVC = TransactionModalVC()
        transactionModalVC.modalPresentationStyle = .overCurrentContext
        transactionModalVC.setupUI(transaction:
                .init(bank: "FakeBank",
                      transactionID: "123456789",
                      merchant: "FakeMerchant",
                      transactionTotal: 2000,
                      date: ""), user: .init(balance: 2500))
        vc.present(transactionModalVC, animated: true)
    }
    
    func addToken(token: String){
        UserDefaults.standard.setValue(token, forKey: tokenKey)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

let tokenKey = "token"

enum LaunchArgument: String{
    case TransactionModal = "TestTransactionModal"
    case promoViewController = "promoViewController"
}
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
