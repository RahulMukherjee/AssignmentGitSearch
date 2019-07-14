//
//  GitServices.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation

class GitServices {
    public static var shared = GitServices()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    private var baseURL = "https://api.github.com/"
    
    //"https://api.github.com/search/users?q=torvalds&page=1"
    private var searchEndpoint = "search/users"
    // https://api.github.com/users/<username>
    private var userEndpoint = "users/"
    //Folower Endpoint "users/torvalds/followers "
    
    public func fetchLogin(login: String,page: String = "1",completion: @escaping (_:Search?,_:Error?)->Void) {
        //Cancel existing url request as it is for swarch so may be user can search for name very frequently
        dataTask?.cancel()
        guard var urlComponent = URLComponents(string: baseURL+searchEndpoint) else {
            completion(nil,GITServicesError.invalidURL)
            return
        }
        urlComponent.query = "q=\(login)&page=\(page)"
        guard let url = urlComponent.url else {
            completion(nil,GITServicesError.invalidURL)
            return
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            guard error == nil, let data = data,let urlResponse = urlResponse as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil,GITServicesError.unknownError("Error in data recieving"))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let search = try decoder.decode(Search.self, from: data)
                completion(search,nil)
            } catch let decodeError {
                 completion(nil,decodeError)
            }
        })
        dataTask?.resume()
    }
    
    ///Fetch imageData from URL
    func getImageData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

