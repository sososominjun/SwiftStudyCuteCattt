//
//  imageService.swift
//  SwiftStudy111
//
//  Created by 소민준 on 9/6/24.
//

import Foundation
import UIKit

class ImageService {
    
    static let shared = ImageService()
    
    enum Network: Error {
        case networkError
    }
    
    private let cash = NSCache<NSString, UIImage>()
    
    func setImage(view: UIImageView, urlString: String) -> URLSessionDataTask? {
        if let image = cash.object(forKey: urlString as NSString) {
            view.image = image
            return nil
        }
        
        return self.downloadImage(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    return
                case .success(let image):
 
                    self.cash.setObject(image, forKey: urlString as NSString)
                    UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve) {
                        
                        view.image = image
                    } completion: { _ in
                        
                    }

                }
            }
        }
    }
    
    
    func downloadImage(urlString: String, completion: @escaping (Result<UIImage, Network>) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, request, error in
            
            guard error == nil else  {
                completion(.failure(.networkError))
                return
                
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
        
        return task
    }
}
