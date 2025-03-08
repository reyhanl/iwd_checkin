//
//  URLManager.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import UIKit

enum URLManager{
    case baseUrl
    case getAttendes(String)
    var url: String{
        switch self{
        case .baseUrl:
            return "api.sheety.co/6a4cc9e4c429a116ebccae75c6ce28e9/untitledSpreadsheet/"
        case .getAttendes(let id):
            return "\(id)"
        }
    }
}

//protocol RequestProtocol{
//    var path: String{get}
//    var header: Header{get}
//    var method: HTTPMethod{get}
//}
//
//enum FeedRequest{
//    case fetchFeeds
//    case likeFeed
//    
//   
//}
//
//struct FeedRequestModel: RequestProtocol{
//    
//    var feedType: FeedRequest
//    
//    var path: String{
//        switch feedType {
//        case .fetchFeeds:
//            return ""
//        case .likeFeed:
//            return ""
//        }
//    }
//    
//    var header: Header{}
//    
//    var method: HTTPMethod
//    
//    
//    init(feedType: FeedRequest, method: HTTPMethod) {
//        self.feedType = feedType
//        self.method = method
//    }
//}
//
//protocol DispatcherProtocol{
//    var environemnt: Environment{ get }
//    func execute(request: Request)
//}
//
//class DispatcheModel: DispatcherProtocol{
//    var environemnt: Environment
//    
//    init(environemnt: Environment) {
//        self.environemnt = environemnt
//    }
//    
//    func execute(request: Request) {
//        
//    }
//}
////
////protocol OperationProtocol{
////    var request: Request
////    
////    func execute<T: Decodable>(completion: @escaping(Result<T, Error>) -> Void)
////}
////
////class LikeFeedOperation: OperationProtocol{
////    var request: Request{
////        return FeedRequestModel(feedType: .likeFeed, method: .get)
////    }
////    
////    func execute<T>(completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
////        
////    }
////}
//
//
//
//enum EnvironmentEnum{
//    case staging
//    case production
//}
//
//class EnvironmentModel{
//    var environmentEnum: EnvironmentEnum
//    var name: String{
//        switch environmentEnum {
//        case .staging:
//            return "staging"
//        case .production:
//            return "production"
//        }
//    }
//    var baseUrl: String{
//        switch environmentEnum {
//        case .staging:
//            return ""
//        case .production:
//            return ""
//        }
//    }
//    init(environmentEnum: EnvironmentEnum) {
//        self.environmentEnum = environmentEnum
//    }
//}
//
//class Header{
//    var dict: [String:Any]
//}

//class ChartView: UIView{
//    
//    func drawPoints(points: [CGPoint]) -> UIBezierPath{
//        var result: [CGPoint] = []
//        var bezierPath = UIBezierPath()
//        for i in 0...100{
//            let currentValue = Double(i) * 0.001
//            for n in 0..<points.count{
//                let nextIndex = n + 1
//                if nextIndex < points.count{
//                    let currentPoint = points[n]
//                    let nextPoint = points[nextIndex]
//                    let point = getPoint(p1: currentPoint, p2: nextPoint, value: currentValue)
//                    result.append(point)
//                }
//            }
//        }
//        var val = 0
//        var count = 0
//        while (val < 100 || count < result.count){
//            val += 1
//            if val == 100{
//                count += 1
//                if count >= result.count{
//                    continue
//                }else{
//                    val = 0
//                }
//            }else{
//                count += 1
//            }
//            let currentValue = count
//            let nextIndex = count + 1
//            if nextIndex < points.count{
//                let currentPoint = points[currentValue]
//                let nextPoint = points[nextIndex]
//                let point = getPoint(p1: currentPoint, p2: nextPoint, value: CGFloat(currentValue))
//                bezierPath.addLine(to: point)
//                
//            }
//        }
//    }
//    
//    override func draw(_ rect: CGRect) {
//        
//    }
//    
//    func getPoint(p1: CGPoint, p2: CGPoint, value: CGFloat) -> CGPoint{
//        let x = p2.x - p1.x * value
//        let y = p2.y - p1.y * value
//        
//        var tempPoint = p1
//        tempPoint.x += x
//        tempPoint.y += y
//        return tempPoint
//    }
//}
