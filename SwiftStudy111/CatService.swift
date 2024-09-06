//
//  CatService.swift
//  SwiftStudy111
//
//  Created by 소민준 on 9/6/24.
//

import Foundation


struct CatResponse: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

final class CatService {
    
    
    enum RequestError: Error {
        case networkError
    }
    
    func getCats(
        page: Int,
        limit: Int,
        completion: @escaping (Result<[CatResponse], RequestError>) -> Void
    ) {
        
        var components = URLComponents(string: "https://api.thecatapi.com/v1/images/search")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            
            guard let response = try? JSONDecoder().decode([CatResponse].self, from: data) else {
                completion(.failure(.networkError))
                return
            }
            print(response)
            
            
            completion(.success(response))
        }
        task.resume()
        
    }
}
