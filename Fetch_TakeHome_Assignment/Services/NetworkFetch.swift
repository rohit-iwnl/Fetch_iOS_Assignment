//
//  NetworkFetch.swift
//  Fetch_TakeHome_Assignment
//
//  Created by Rohit Manivel on 3/7/24.
//

import Foundation

class NetworkFetch{
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void){
        let endpoint = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        guard let url = URL(string: endpoint) else{
            completion(.failure(NSError(domain: "Invalid URL", code: 404,userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in if let error = error{
            completion(.failure(error))
            return
        }
            
        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: 503, userInfo: nil)))
            return
        }
        
        do{
            let items = try JSONDecoder().decode([Item].self, from:data)
            completion(.success(items))
        }catch{
            completion(.failure(error))
        }
        
        }.resume()
    }
}
