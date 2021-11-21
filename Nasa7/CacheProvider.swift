//
//  CacheProvider.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 21.11.2021.
//

import Foundation

protocol CacheProviderProtocol {
    func retrieve (key: String) -> Data?
    func save (key: String, value: Data)
}

class CacheProvider {
    private var values = [String: Data]()
    private let queue = DispatchQueue (label: "cacheQueue", qos: .userInitiated, attributes: .concurrent)
}

extension CacheProvider: CacheProviderProtocol {
    func retrieve(key: String) -> Data? {
        queue.sync {
            return values[key]
        }
        
    }
    //ARC - снова прочитать. Я не вижу, что на что ссылается тут.
    func save(key: String, value: Data) {
        queue.async(flags: .barrier) { [weak self] in
            self?.values[key] = value
        }
    }
    
    
}
