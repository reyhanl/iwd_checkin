//
//  HomeInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class HomeInteractor: HomePresenterToInteractorProtocol{
    var presenter: HomeInteractorToPresenterProtocol?
        
    func userDidScanQR(text: String, attendes: [Attende]) {
        if let attende = attendes.first(where: {$0.email.lowercased() == text.lowercased()}){
            let alreadyEnter = logAttendance(attende: attende)
            if alreadyEnter{
                presenter?.result(result: .success(.qrIsValidButReenter(attende)))
            }else{
                presenter?.result(result: .success(.qrIsValid(attende)))
            }
        }else{
            presenter?.result(result: .failure(CustomError.qrIsInvalid))
        }
    }
    
    func logAttendance(attende: Attende) -> Bool{
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            let log = Log(attende: attende)
            let predicate = NSPredicate(format: "email = %@", attende.email)
            let alreadyEnter = helper.checkIfDataAlreadyExist(entity: .log, predicate: predicate)
            try helper.saveNewData(entity: .log, object: log)
            return alreadyEnter
        }catch{
            return false
        }
    }
    
    func storeToCoreData(attendes: [Attende]){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            try helper.deleteAllRecords(entity: .attende)
            for attende in attendes{
                try helper.saveNewData(entity: .attende, object: attende)
            }
        }catch{
            
        }
    }
    
    func fetchListOfAttendes(from sheet: String){
        let tempAttendes: [Attende] = []
//            self.presenter?.result(result: .success(.fetchAttendesSuccess(resp.data)))
        NetworkManager.shared.request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getAttendes(sheet).url, queryItems: []) { (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let resp):
                self.storeToCoreData(attendes: resp.data)
                self.presenter?.result(result: .success(.fetchAttendesSuccess(resp.data)))
            case .failure(let failure):
                self.presenter?.result(result: .failure(CustomError.sheetNotFound))
            }
        }
        
    }
}
//
//struct MockDataProvider{
//    static func generateAttendes() -> Attende{
//        let dummyAttendees: [Attende] = [
//            Attende(name: "John Doe", email: "john.doe@example.com", number: "+1234567890"),
//            Attende(name: "Jane Smith", email: "jane.smith@example.com", number: "+0987654321"),
//            Attende(name: "Alice Johnson", email: "alice.johnson@example.com", number: "+1122334455"),
//            Attende(name: "Bob Brown", email: "bob.brown@example.com", number: "+2233445566"),
//            Attende(name: "Charlie Davis", email: "charlie.davis@example.com", number: "+3344556677"),
//            Attende(name: "Diana Evans", email: "diana.evans@example.com", number: "+4455667788"),
//            Attende(name: "Edward Wilson", email: "edward.wilson@example.com", number: "+5566778899"),
//            Attende(name: "Fiona Garcia", email: "fiona.garcia@example.com", number: "+6677889900"),
//            Attende(name: "George Harris", email: "george.harris@example.com", number: "+7788990011"),
//            Attende(name: "Hannah Martinez", email: "hannah.martinez@example.com", number: "+8899001122")
//        ]
//        return dummyAttendees
//    }
//}

struct APIResponse: Codable{
    var data: [Attende]
}

struct Attende: Codable{
    var name: String
    var email: String
    var number: String
    var haveEntered: Bool = false
    
    enum CodingKeys: String, CodingKey{
        case name = "name"
        case email = "email"
        case number = "whatsAppNumber"
        case haveEntered = "haveEntered"
    }
    
    init(name: String, email: String, number: String) {
       self.name = name
       self.email = email
       self.number = number
   }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        if let intValue = try? container.decode(Int.self, forKey: .number) {
            number = String(intValue)
        } else if let stringValue = try? container.decode(String.self, forKey: .number) {
            number = stringValue
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value is neither an integer nor a string"))
        }
        haveEntered = try container.decodeIfPresent(Bool.self, forKey: .haveEntered) ?? false
    }
}

struct Log: Codable{
    var name: String
    var email: String
    var date: String
    
    init(name: String, email: String, date: String) {
        self.name = name
        self.email = email
        self.date = date
    }
    
    init(attende: Attende){
        self.name = attende.name
        self.email = attende.email
        self.date = Date().toString()
    }
}
