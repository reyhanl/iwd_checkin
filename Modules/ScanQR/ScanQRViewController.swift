//
//  ScanQRViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import AVKit

class ScanQRViewController: BaseViewController, CustomTransitionEnabledVC, ScanQRPresenterToViewProtocol{
    
    var presenter: ScanQRViewToPresenterProtocol?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    let session = AVCaptureSession()
    var delegate: ScanQRDelegate?
    var shouldStopScanning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        addPanGestureRecognizer()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldStopScanning = false
    }
    
    deinit{
        DispatchQueue.global().async { [weak self] in
            self?.session.stopRunning()
        }
        delegate = nil
    }
    
    // MARK: - set up camera
    func setupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.startSession()
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.startSession()
                    }
                }
            }
        case .denied, .restricted:
            self.presentErrorAlert(title: "Permission needed", message: "You need to change the camera permission for this app to be enabled")
            return
        default:
            break
        }
        
    }
    
    func startSession(){
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [.qr]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global().async { [weak self] in
                self?.session.startRunning()
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    func addButton(){
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -50),
            NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        ])
        
        button.addTarget(self, action: #selector(continueCamera), for: .touchUpInside)
        button.backgroundColor = .lightGray
    }
    
    func presentErrorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .destructive) { [weak self] alert in
            self?.shouldStopScanning = false
            DispatchQueue.global().async { [weak self] in
                self?.session.startRunning()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    //MARK: Presenter to view handler
    func result(result: Result<ScanQRSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            switch error{
            case CustomError.unableToScanQRCode:
                presentErrorAlert(title: "QR Code malformed", message: CustomError.unableToScanQRCode.errorDescription ?? "")
            default:
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func handleSuccess(type: ScanQRSuccessType){
        switch type {
        case .decodeQR(let transaction):
            self.delegate?.successfullyScanQR(text: transaction)
        }
    }
    
    @objc func continueCamera(){
        DispatchQueue.global().async { [weak self] in
            self?.session.startRunning()
        }
    }
}

//MARK: TransitionHandler
extension ScanQRViewController{
    func addPanGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleTransition(_ gestureRecognizer: UIPanGestureRecognizer){
        let translationX = gestureRecognizer.translation(in: view).x
        let percentageInDecimal = -translationX / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            customTransitionDelegate.dismissalTransitionType = .swipeLeft
            dismiss(animated: true)
        case .changed:
            print(percentageInDecimal)
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
        default:
            break
        }
    }
    
}

//MARK: QRCode handler
extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let stringValue = metadataObject.stringValue else { return }
        guard !shouldStopScanning else{return}
        shouldStopScanning = true
        print("metadataOutput")
        DispatchQueue.global().async { [weak self] in
            self?.session.stopRunning()
            DispatchQueue.main.async {
                self?.presenter?.userDidScanQR(qrString: stringValue)
            }
        }
    }
}

protocol ScanQRDelegate{
    func successfullyScanQR(text: String)
}
