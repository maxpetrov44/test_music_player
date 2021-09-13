//
//  TrackInfo.swift
//  image_load_demo
//
//  Created by Max Petrov on 02.09.2021.
//

import Foundation
import RealmSwift


@objcMembers
class DetailedTrackInfo: Object, Decodable, NSCopying {
    dynamic var imageData: Data?
    dynamic  var trackId: Int
    dynamic var artistName: String
    dynamic var trackName: String
   // let collectionName: String
    dynamic var artworkUrl60: String
    dynamic var artworkUrl100: String
    dynamic var previewUrl: String
    dynamic var isFavourite : Bool
    //let primaryGenreName: String
    
    enum CodingKeys: CodingKey {
        case trackId, artistName, trackName, artworkUrl60, artworkUrl100, previewUrl
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackId = try values.decode(Int.self, forKey: .trackId)
        artistName = try values.decode(String.self, forKey: .artistName)
        trackName = try values.decode(String.self, forKey: .trackName)
        artworkUrl60 = try values.decode(String.self, forKey: .artworkUrl60)
        artworkUrl100 = try values.decode(String.self, forKey: .artworkUrl100)
        previewUrl = try values.decode(String.self, forKey: .previewUrl)
        imageData = nil
        isFavourite = false
    }
    override init() {
        imageData = nil
        trackId = 0
        artistName = ""
        trackName = ""
        artworkUrl60 = ""
        artworkUrl100 = ""
        previewUrl = ""
        isFavourite = false
    }
    init(imageData: Data?, trackId: Int, artistName: String, trackName: String, artworkUrl60: String, artworkUrl100: String, previewUrl: String, isFavourite: Bool) {
        self.imageData = imageData
        self.trackId = trackId
        self.artistName = artistName
        self.trackName = trackName
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.isFavourite = isFavourite
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DetailedTrackInfo.init(imageData: imageData, trackId: trackId, artistName: artistName, trackName: trackName, artworkUrl60: artworkUrl60, artworkUrl100: artworkUrl100, previewUrl: previewUrl, isFavourite: isFavourite)
        return copy
    }
}



