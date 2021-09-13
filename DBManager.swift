//
//  DBManager.swift
//  image_load_demo
//
//  Created by Max Petrov on 10.09.2021.
//

import Foundation
import RealmSwift




protocol DBManager {

    static var shared : DBManager { get }
    func save(_ value: DetailedTrackInfo)
    func delete(_ value: DetailedTrackInfo)
    func obtain() -> [DetailedTrackInfo]
    
}

class DBManagerImpl: DBManager {
    static var shared: DBManager = DBManagerImpl()
    let realm = try! Realm()
    func save(_ value: DetailedTrackInfo) {
        do {
            try realm.write {
                realm.add(value)
            }
        } catch let error {
            print(error)
        }
    }
    
    func delete(_ value: DetailedTrackInfo) {
        let filter = realm.objects(DetailedTrackInfo.self).filter {
            $0.trackId == value.trackId
        }
        do {
           try filter.forEach {element in
                try realm.write {
                    realm.delete(element)
                }
            }
            
        } catch let error {
            print(error)
        }
    }
    
    func obtain() -> [DetailedTrackInfo] {
        let track = realm.objects(DetailedTrackInfo.self)
        return track.sorted(by: {
            $0.trackName > $1.trackName
        })
    }
}
