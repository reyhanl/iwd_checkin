//
//  CustomRefreshControl.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 02/06/24.
//

import UIKit

class CustomRefreshControl: UIRefreshControl{
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var isAnimating = false
    fileprivate let maxPullDistance: CGFloat = 150
    var duration: CGFloat = 0.5
    var currentIndex: Int = 0{
        didSet{
            if currentIndex >= frameIntervals.count{
                currentIndex = 0
            }
            print(currentIndex)
            imageView.image = UIImage(named: loop.getName(index: currentIndex))
        }
    }
    var frameIntervals = [TimeInterval]()
    var timer: Timer?
    var loop: LoadingState = .firstLoop
    
    override init() {
        super.init(frame: .zero)
        setupView()
        addImageView()
        calculateEaseInIntervals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // hide default indicator view
        tintColor = .clear

        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
    }
    
    func updateProgress(with offsetY: CGFloat) {
        guard !isAnimating else { return }
        var progress = offsetY / maxPullDistance * 100
        currentIndex = Int(progress) * -1
        print(currentIndex)
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        isAnimating = true
        currentIndex = 0
        calculateEaseInIntervals()
        animate(with: frameIntervals[currentIndex], index: currentIndex)
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        timer?.invalidate()
        isAnimating = false
    }
    
    func addImageView(){
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func animate(with time: CGFloat, index: Int){
        var index = index
        if index >= frameIntervals.count{
            index = 0
            loop = loop == .firstLoop ? .secondLoop:.firstLoop
        }
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
            self.currentIndex = index
            self.animate(with: self.frameIntervals[index], index: index + 1)
        }
    }
    
    func calculateEaseInIntervals() {
        var currentFrame = 0
        let totalFrames = 100
        var intervals = [TimeInterval]()
        for i in 0..<totalFrames {
            let normalizedTime = pow(Double(i) / Double(totalFrames - 1), 2)
            intervals.append(normalizedTime)
        }

        // Normalize the intervals to sum to the desired total duration
        let totalDuration: TimeInterval = duration // Total duration of the GIF in seconds
        let totalSum = intervals.reduce(0, +)
        let scalingFactor = totalDuration / totalSum
        
        frameIntervals = intervals.map { $0 * scalingFactor }
    }

}

enum LoadingState{
    case firstLoop
    case secondLoop
    
    mutating func toggle(){
        switch self{
        case .firstLoop:
            self = .secondLoop
        case .secondLoop:
            self = .firstLoop
        }
    }
    
    func getName(index: Int) -> String{
        switch self {
        case .firstLoop:
            return "\(index)"
        case .secondLoop:
            return "Mask group-\(index)"
        }
    }
}
