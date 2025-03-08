//
//  ViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import Combine
import MessageUI

class HomeViewController: BaseViewController, CustomTransitionEnabledVC, HomePresenterToViewProtocol, MFMailComposeViewControllerDelegate {
    
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    lazy var noTransactionView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var balanceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: "noDataCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.accessibilityIdentifier = "tableView"
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    lazy var topUpButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(.init(color: .primaryButton), for: .normal)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .selected)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .highlighted)
        button.setTitle("Top up", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var presenter: HomeViewToPresenterProtocol?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    var balance: Double = 0
    var transactions: [Transaction] = []
    var firstTime: Bool = true
    var user: User?
    var frameIntervals = [TimeInterval]()
    var refreshControl: CustomRefreshControl?
    var backgroundType: BackgroundName = .bnw
    
    override func viewDidLoad() {
        super.viewDidLoad()
//            if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//                mail.mailComposeDelegate = self
//                mail.setToRecipients(["artube090@gmail.com"])
//                let html = """
//<html lang="en">
//<head>
//    <meta charset="UTF-8">
//    <meta name="viewport" content="width=device-width, initial-scale=1.0">
//    <title>Event Confirmation</title>
//</head>
//<body style="font-family: Arial, sans-serif; line-height: 1.6;">
//    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
//        <h2 style="color: #4CAF50;">Confirmation for Monthly Coffee Chat Event!</h2>
//        <p>Dear {name},</p>
//        <p>Thank you for RSVPing to our Monthly Coffee Chat-ONSITE Event! We are excited to have you join us. Here are the event details:</p>
//        
//        <div style="background-color: #f9f9f9; padding: 10px; border-left: 6px solid #4CAF50;">
//            <p><strong>📅 Date:</strong> Tuesday, 11th June 2024<br>
//            <strong>🕕 Time:</strong> 07.30 PM - 9 PM<br>
//            <strong>📍 Location:</strong> Apple Developer Academy @UC, Surabaya</p>
//        </div>
//        
//        <hr>
//        
//        <p><strong>Additional Notes:</strong></p>
//        <ul>
//            <li><strong>Arrival:</strong> Please arrive 10 minutes before the start time to ensure a timely start.</li>
//            <li><strong>Health and Safety:</strong> In light of ongoing health and safety measures, please ensure you follow all local guidelines regarding COVID-19 protocols.</li>
//            <li><strong>Contact:</strong> If you have any questions or need further assistance, feel free to contact us at [Your Contact Information].</li>
//        </ul>
//        
//        <p>Thank you for your participation, and we look forward to seeing you soon!</p>
//    </div>
//</body>
//</html>
//"""
//                mail.setMessageBody(html, isHTML: true)
//
//                present(mail, animated: true)
//            } else {
//                // show failure alert
//            }
        
        addBackgroundView()
        addPanGestureRecognizer()
        addScanQRButton()
        addNoTransactionView()
        addTableView()
        presenter?.viewDidLoad()
        self.edgesForExtendedLayout = .all  
        self.tableView.contentInset = .zero
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Registrant"
        backgroundView.transform = backgroundView.transform.rotated(by: 1.57)
        backgroundView.image = UIImage(named: backgroundType.homeBackgroundName)

//        view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        backgroundView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let backgroundString = UserDefaults.standard.value(forKey: UserDefaultKey.background.rawValue) as? String,
            let temp = BackgroundName(rawValue: backgroundString){
            backgroundType = temp
            backgroundView.image = UIImage(named: backgroundType.homeBackgroundName)
        }
    }
    
    func addBackgroundView(){
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: (UIScreen.current?.bounds.height ?? 0) * 2),
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: (UIScreen.current?.bounds.height ?? 0) * 2),
        ])
    }
    
    func addUserDetailView(){
        view.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: balanceLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: balanceLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: balanceLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 100)
        ])
    }
    
    func addTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        addRefreshControl()
    }
    
    func addRefreshControl(){
        let customRefreshControl = CustomRefreshControl()
        tableView.refreshControl = customRefreshControl
        customRefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = customRefreshControl
    }
    
    func addNoTransactionView(){
        view.addSubview(noTransactionView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: noTransactionView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0.5)
        ])
    }
    
    func addTopUpButton(){
        view.addSubview(topUpButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: topUpButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: topUpButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topUpButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: topUpButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.8, constant: 0)
        ])
    }
    
    
    func addPanGestureRecognizer(){
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        panGesture.edges = .left
        
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(panGesture)
    }
    
    func addScanQRButton(){
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "qrcode.viewfinder"), style: .done, target: self, action: #selector(presentQRVC))
    }
    
    func presentAlertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "OK", style: .destructive))
        self.present(alertController, animated: true)
    }
    
    func endRefresh() {
        refreshControl?.endRefreshing()
    }
    
    func updateAttendes(attendes: [Attende]) {
        tableView.reloadData()
    }
    
    func updateUserInfo(user: User) {
        self.user = user
        self.navigationItem.title = user.balance.getCurrency()
    }
    
    @objc func presentQRVC(){
        presentScanQRVC(usingInteraction: false)
    }
    
    func presentScanQRVC(usingInteraction: Bool){
        presenter?.goToQRVC(from: self, usingInteraction: usingInteraction)
    }

    
    @objc func handleTransition(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer){
        let translationX = gestureRecognizer.translation(in: view).x
        let percentageInDecimal = translationX / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            presentScanQRVC(usingInteraction: true)
        case .changed:
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }
    
    @objc func refreshData(){
        presenter?.refreshData()
    }
}

extension HomeViewController: ScanQRDelegate{
    func successfullyScanQR(text: String) {
        self.dismiss(animated: true) {
            self.presenter?.userDidScanQR(text: text)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter?.numberOfRows() == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell", for: indexPath) as! NoDataTableViewCell
            tableView.accessibilityIdentifier = "noDataCell"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
            if let attende = presenter?.attendeForRow(at: indexPath.row),
               let alreadyEntered = presenter?.checkIfAlreadyEnter(attende: attende)
            {
                cell.setupCell(attende: attende, haveEntered: alreadyEntered)
            }
            tableView.accessibilityIdentifier = "transactionTableViewCell\(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (presenter?.numberOfRows() == 0) ? tableView.frame.height:UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else{return 0}
        return presenter.numberOfRows() == 0 ? 1:presenter.numberOfRows()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rotationAngle = scrollView.contentOffset.y / 10000
        backgroundView.transform = backgroundView.transform.rotated(by: rotationAngle)
        refreshControl?.updateProgress(with: scrollView.contentOffset.y)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let attende = presenter?.attendeForRow(at: indexPath.row).email
        let markAsAttendAction = UIContextualAction(style: .normal, title: "Mark as Attended") { _, _, completion in
            self.presenter?.userDidScanQR(text: attende ?? "")
        }
        
        markAsAttendAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [markAsAttendAction])
    }
}

extension HomeViewController: TransactionModalDelegate{
    func purchase(transaction: Transaction){
        dismiss(animated: true) { [weak self] in
            guard let self = self else{return}
        }
    }
}

extension Notification.Name{
    static let newTransaction = Notification.Name("newTransaction")
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

enum BackgroundName: String{
    case color = "color"
    case bnw = "bnw"
    
    var rotatingBackgroundName: String{
        switch self{
        case .bnw:
            return "rotatingBackground"
        case .color:
            return "rotatingColoredBackground"
        }
    }
    
    var homeBackgroundName: String{
        switch self{
        case .bnw:
            return "backgroundOne"
        case .color:
            return "backgroundColor"
        }
    }
    
    var onBoardingImage: String{
        switch self{
        case .bnw:
            return "onBoardingwhite"
        case .color:
            return "onboarding"
        }
    }
}
