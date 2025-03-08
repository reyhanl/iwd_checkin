//
//  NetworkManager.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation

class NetworkManager: NetworkManagerProtocol, SearchNetworkProtocol{
    
    static var shared = NetworkManager()
    
    internal func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void)){
        var components = URLComponents()
        components.queryItems = queryItems
        guard let url = URL(string: "https://" + URLManager.baseUrl.url + url) else{completion(.failure(CustomError.callApiFailBecauseURLNotFound));return}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
//        request.setValue("application/json", forHTTPHeaderField: "accept")
//        if let apiKey = UserDefaults.standard.value(forKey: "apiKey"){
//            request.setValue("Bearer \(GummyBear)", forHTTPHeaderField: "Authorization")
//        }
        request.setValue("Bearer GummyBear", forHTTPHeaderField: "Authorization")
//
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(.failure(CustomError.apiReturnNoData))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode >= 200 else{
                DispatchQueue.main.async{
                    completion(.failure(CustomError.somethingWentWrong))
                }
                return
            }
            guard let key = UserDefaults.standard.value(forKey: UserDefaultKey.tempSheetID.rawValue) as? String else{
                DispatchQueue.main.async{
                    completion(.failure(CustomError.somethingWentWrong))
                }
                return
            }

            
            //            print(httpResponse)
            var decoder = JSONDecoder()
            do{
                let dict = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                guard let secondTempDict = dict?[key] as? [[String:Any]] else{return}
                print("data: \(secondTempDict)")
                let newData = try JSONSerialization.data(withJSONObject: secondTempDict, options: .fragmentsAllowed)
                print(newData)
                var model = try decoder.decode(T.self, from: newData)
                DispatchQueue.main.async{
                    completion(.success(model))
                }
            }catch{
                print(String(describing: error))
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping(Result<[Category], Error>) -> Void){
    }
    
    func loadFromJSON<T: Decodable>(_ type: T.Type) -> T?{
        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                return model
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return nil
    }
}

protocol Dispatcher {
    
    /// Configure the dispatcher with an environment
    ///
    /// - Parameter environment: environment configuration
    init(environment: Environment)
    
    
    
    /// This function execute the request and provide a Promise
    /// with the response.
    ///
    /// - Parameter request: request to execute
    /// - Returns: promise
    func execute<T: Decodable>(request: Request, completion: @escaping((Result<T, Error>) -> Void))
    
}

public class NetworkDispatcher: Dispatcher{
    
    var environment: Environment
    
    var session: URLSession
    
    required init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func execute<T>(request: Request, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
        guard let rq = self.prepareURLRequest(for: request) else{return}
        let d = self.session.dataTask(with: rq, completionHandler: { (data, urlResponse, error) in
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else{
                completion(.failure(CustomError.apiReturnNoData))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode >= 200 else{
                completion(.failure(CustomError.somethingWentWrong))
                return
            }
            //            print(httpResponse)
            var decoder = JSONDecoder()
            do{
                var model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }catch{
                print(String(describing: error))
                completion(.failure(error))
            }
        })
        d.resume()
    }
    
    private func prepareURLRequest(for request: Request) -> URLRequest? {
            // Compose the url
            let full_url = "\(environment.host)/\(request.path)"
            var url_request = URLRequest(url: URL(string: full_url)!)
            
            // Working with parameters
            switch request.parameters {
            case .body(let params):
                // Parameters are part of the body
                if let params = params as? [String: String] { // just to simplify
                    do{
                        url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
                    }catch{
                        
                    }
                }
            case .url(let params):
                // Parameters are part of the url
                if let params = params as? [String: String] { // just to simplify
                    let query_params = params.map({ (element) -> URLQueryItem in
                        return URLQueryItem(name: element.key, value: element.value)
                    })
                    guard var components = URLComponents(string: full_url) else {
                        return nil
                    }
                    components.queryItems = query_params
                    url_request.url = components.url
                }
            }
            
            // Add headers from enviornment and request
            environment.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
            request.headers?.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
            
            // Setup HTTP method
        url_request.httpMethod = request.httpMethod.rawValue
            
            return url_request
        }
}

public struct Environment {
    
    /// Name of the environment
    public var name: String
    
    /// Base URL of the environment
    public var host: String
    
    /// This is the list of common headers which will be part of each Request
    /// Some headers value maybe overwritten by Request's own headers
    public var headers: [String: Any] = [:]
    
    /// Cache policy
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    /// Initialize a new Environment
    ///
    /// - Parameters:
    ///   - name: name of the environment
    ///   - host: base url
    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
}

protocol Operation {
    
    /// Request to execute
    var request: Request { get }
    
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - Returns: a promise
    func execute<T: Decodable>(in dispatcher: Dispatcher, completion: @escaping((Result<T, Error>) -> Void))
    
}

enum CategoryRequest: Request{
    
    case fetchCategories
    
    var dataType: DataType{
        switch self{
        case .fetchCategories:
            return .Data
        }
    }
    
    var parameters: RequestParams{
        switch self{
        case .fetchCategories:
            return .url([:])
        }
    }
    
    var path: String{
        switch self{
        case .fetchCategories:
            return "category/v1/tree/all"
        }
    }
    
    var httpMethod: HTTPMethod{
        switch self{
        case .fetchCategories:
            return .get
        }
    }
    
    var contentType: ContentType{
        switch self{
        case .fetchCategories:
            return .formUrlEncoded
        }
    }
    
    var headers: [String:Any]?{
        switch self{
        case .fetchCategories:
            return nil
        }
    }
    
}

protocol Request{
    var path: String{get}
    var httpMethod: HTTPMethod{get}
    var contentType: ContentType{get}
    var parameters : RequestParams{ get }
    var dataType : DataType{get}
    var headers: [String : Any]?{get}
}

public enum DataType {
    case JSON
    case Data
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

enum HTTPMethod: String{
    case post = "POST"
    case put  = "PUT"
    case get  = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum ContentType: String{
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

protocol NetworkManagerProtocol{
    func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void))
}

protocol SearchNetworkProtocol{
    func fetchCategories(completion: @escaping(Result<[Category], Error>) -> Void)
}
