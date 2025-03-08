//
//  CoreDataManager.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import CoreData

class CoreDataStack {
    
    var modelContainerName: String?
    var persistentContainer: NSPersistentContainer?
    var context: NSManagedObjectContext?
    var description: [NSPersistentStoreDescription]?
    
    init(name: DataContainer, type: [NSPersistentStoreDescription]? = nil){
        self.modelContainerName = name.rawValue
        self.description = type
        assignContainer()
        assignContext()
    }
    
    init(persistent container: NSPersistentContainer){
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        
        self.persistentContainer = container
        self.context = container.viewContext
    }
    
    private func assignContainer(){
        guard let name = modelContainerName else{return}
        let container = NSPersistentContainer(name: name)
        if let description = UserDefaults.standard.string(forKey: "testing"){
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        if let description = description{
            container.persistentStoreDescriptions = description
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        self.persistentContainer = container
    }
    
    private func assignContext(){
        self.context = persistentContainer?.viewContext
    }
    
}

class CoreDataHelper: CoreDataHelperProtocol {
    
    var stack: CoreDataStack?
    
    required init(coreDataStack: CoreDataStack){
        self.stack = coreDataStack
    }
    
    //TODO: Make this to be generic
    func saveNewData<T: Encodable>(entity name: EntityName, object: T) throws{
        guard let context = stack?.context
        else{
            throw CustomError.contextIsNotDefinedCoreDataStack
        }
        let entity = NSEntityDescription.entity(forEntityName: name.rawValue, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        do{
            let decoder = DictionaryEncoder()
            let dict = try decoder.encode(object)
            
            //We have to filter out some key that we don't have in CoreData but present in the Encodable object
            let keys = newUser.entity.attributesByName.keys
            print(keys)
            let validKeys = Set(keys)
            let filteredDictionary = dict.filter { validKeys.contains($0.key) }
            newUser.setValuesForKeys(filteredDictionary)
            
            try context.save()
        }
    }
    
    func checkIfDataAlreadyExist(entity name: EntityName, predicate: NSPredicate) -> Bool{
        guard let context = stack?.context else{
            return false
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let values = result as! [NSManagedObject]
            return values.count > 0
        } catch {
            
            print("Failed")
        }
        return false
    }
    
    func fetchItems(entity name: EntityName, with predicate: NSPredicate?) throws -> [NSManagedObject] {
        guard let context = stack?.context else{
            throw CustomError.contextIsNotDefinedCoreDataStack
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        if let predicate = predicate{
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        } catch {
            
            print("Failed")
        }
        return []
    }
    
    func fetchItemsToGeneric<T: Codable>(entity name: EntityName, with predicate: NSPredicate?) throws -> [T] {
        guard let context = stack?.context else{
            throw CustomError.contextIsNotDefinedCoreDataStack
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        if let predicate = predicate{
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            print(result.count)
            let models = try result.map({
                let dict = $0.dict
                let data = try JSONSerialization.data(withJSONObject: dict)
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                return model
            })
            return models
        }
    }
    
    func deleteRecords(entity name: EntityName, with predicate: NSPredicate) throws {
        guard let context = stack?.context
        else{
            throw CustomError.contextIsNotDefinedCoreDataStack
        }
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
    }
    
    
    func deleteAllRecords(entity name: EntityName) throws{
        guard let context = stack?.context
        else{
            throw CustomError.contextIsNotDefinedCoreDataStack
        }
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
    }
    
    
    
    //make this func to be dependency injection, like making the func to be able to fetch any data from any storage and return any kind of data user want using generic
    //add that to UnitTest
}

protocol CoreDataHelperProtocol{
    var stack: CoreDataStack?{get set}
    
    init(coreDataStack: CoreDataStack)
    func fetchItems(entity name: EntityName, with predicate: NSPredicate?) throws -> [NSManagedObject]
    //TODO: You can make fetchItems to return to Codable object, but in this case it seems a little bit excessive because we only store the name
    func fetchItemsToGeneric<T: Codable>(entity name: EntityName, with predicate: NSPredicate?) throws -> [T]
    func deleteRecords(entity name: EntityName, with predicate: NSPredicate) throws
    func deleteAllRecords(entity name: EntityName) throws
    func saveNewData<T: Encodable>(entity name: EntityName, object: T) throws
}

enum DataContainer{
    case main
    
    var rawValue: String{
        switch self{
        case .main:
            return "Test_Reyhan"
        }
    }
}

enum EntityName{
    case transaction
    case user
    case attende
    case log
    case custom(String)
    
    var rawValue: String{
        switch self{
        case .transaction:
            return "TransactionEntity"
        case .user:
            return "UserEntity"
        case .attende:
            return "AttendeEntity"
        case .log:
            return "LogEntity"
        case .custom(let entity):
            return entity
        }
    }
}
