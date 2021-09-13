//
//  NetworkService.swift
//  image_load_demo
//
//  Created by Max Petrov on 02.09.2021.
//

import Foundation
import SwiftyJSON


class NetworkService {
    func downloadImage(_ urlString: String, completion: @escaping (Data?) -> Void)  {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared
            .dataTask(with: url) {(data, response, error) in
                guard let data = data else {return}
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        task.resume()
    }
    
    func downloadInfo(_ urlString: String, completion: @escaping ([DetailedTrackInfo]) -> Void) {
        guard let url = URL(string: urlString) else {return }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            print("Done!")
            guard let data = data else { return }
            do {
                let json = JSON(data)
                let downloadedInfo = try json["results"].rawData()
                let result = try JSONDecoder().decode([DetailedTrackInfo].self, from: downloadedInfo)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func downloadTrack(_ urlString: String, completion: @escaping (URL) -> Void ) {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            guard let url = url else {return}
            completion(url)
        }
        task.resume()
    }
}


