//
//  NSManagedObject+Extension.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import CoreData

extension NSManagedObject{
    var dict: [String:Any]{
        let keys = Array(self.entity.attributesByName.keys)
        let dict = self.dictionaryWithValues(forKeys: keys)
        return dict
    }
}
