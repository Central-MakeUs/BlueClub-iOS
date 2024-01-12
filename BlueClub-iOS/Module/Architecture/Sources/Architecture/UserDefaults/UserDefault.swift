//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<T: Codable> {
    
    let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let loadedObject = try? decoder.decode(T.self, from: savedData) {
                    return loadedObject
                }
            }
            return .none
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}
