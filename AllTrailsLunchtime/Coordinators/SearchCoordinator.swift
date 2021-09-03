//
//  SearchCoordinator.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//

import UIKit
import Foundation

class SearchCoordinator: NSObject {
    public func downloadBy(keyword: String, completion: @escaping(_ source: [RestaurantModel]?, _ errorMessage: String?) -> Void) {
        guard let searchText = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil, "Keyword isn't valid.")
            return
        }

        let requestString = "+\(searchText)"
        download(requestString: requestString, completion: completion)
    }
    
    public func downloadBy(latitude: Double, longitude: Double, completion: @escaping(_ source: [RestaurantModel]?, _ errorMessage: String?) -> Void) {
        let requestString = "&location=\(latitude),\(longitude)&radius=10"
        download(requestString: requestString, completion: completion)
    }
    
    private func download(requestString: String, completion: @escaping(_ source: [RestaurantModel]?, _ errorMessage: String?) -> Void) {
        let configurations = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
        
        guard let url = configurations[apiUrlKey] as! String?,
              let accessKey = configurations[apiAccessKey] as! String? else {
            completion(nil, "Access Key and / or URL isn't found.")
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let requestUrl = "\(url)restaurant\(requestString)&key=\(accessKey)"
        let callURL = URL.init(string: requestUrl)
        var request = URLRequest.init(url: callURL!)
        
        request.timeoutInterval = 30.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            guard error == nil,
                  let data = data else {
                completion(nil, error?.localizedDescription ?? "No data")
                return
            }
                
            do {
                let response = try JSONDecoder().decode(AllResponse.self, from: data)
                print(response)
                
                guard let results = response.results else {
                    completion(nil, "Not successful")
                    return
                }
                let list = results.map {$0.toModel() }
                completion(list, nil)
            } catch {
                print("Error 😫 = \(error)")
                completion(nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
