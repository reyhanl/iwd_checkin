import UIKit

class LoadingView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var frameIntervals: [CGFloat] = []
    var duration: CGFloat = 1
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex >= frameIntervals.count {
                currentIndex = 0
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(named: self.loop.getName(index: self.currentIndex))
            }
        }
    }
    
    var loop: LoadingState = .firstLoop
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(duration: CGFloat) {
        self.init(frame: .zero)
        self.duration = duration
        calculateEaseInIntervals()
    }
    
    func addImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func startLoading() {
        animate(with: frameIntervals[0], index: 0)
    }
    
    func animate(with time: CGFloat, index: Int) {
        var index = index
        if index >= frameIntervals.count {
            index = 0
            loop = loop == .firstLoop ? .secondLoop : .firstLoop
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            self.currentIndex = index
            self.animate(with: self.frameIntervals[index], index: index + 1)
        }
    }
    
    func calculateEaseInIntervals() {
        let totalFrames = 100
        var intervals = [TimeInterval]()
        for i in 0..<totalFrames {
            let normalizedTime = pow(Double(i) / Double(totalFrames - 1), 2)
            intervals.append(normalizedTime)
        }
        
        // Normalize the intervals to sum to the desired total duration
        let totalDuration: TimeInterval = TimeInterval(duration)
        let totalSum = intervals.reduce(0, +)
        let scalingFactor = totalDuration / totalSum
        
        frameIntervals = intervals.map { CGFloat($0 * scalingFactor) }
    }
    
    func stopLoading() {
        timer?.invalidate()
        currentIndex = 0
    }
}

