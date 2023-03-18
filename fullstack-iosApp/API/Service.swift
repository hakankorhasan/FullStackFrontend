//
//  Service.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 20.01.2023.
//

import Alamofire

class Service: NSObject {
    
    static let shared = Service()
        
    let baseUrl = "http://localhost:1337"
    
    func searchForUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        let url = "\(baseUrl)/search"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let error = dataResponse.error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    let data = dataResponse.data ?? Data()
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch(let err) {
                    completion(.failure(err))
                }
          }
        
    }
    
    func followingForUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        let url = "\(baseUrl)/following"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let error = dataResponse.error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    let data = dataResponse.data ?? Data()
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch(let err) {
                    completion(.failure(err))
                }
          }
    }
    
    
    func login(email: String, passwoord: String, completion: @escaping (Result<Data, Error>) -> ()){
        let params = ["emailAddress": email, "password": passwoord]
        let url = "\(baseUrl)/api/v1/entrance/login"
        AF.request(url, method: .put, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                } else {
                    completion(.success(dataResp.data ?? Data()))
                }
            }
    }
    
    func signUp(fullName: String, email: String, password: String, completion: @escaping (Result<Data, Error>) -> ()) {
        
        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                completion(.success(dataResp.data ?? Data()))
            }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
       let url = "\(baseUrl)/post"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResp.data else { return }
                
                do{
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                }catch {
                    completion(.failure(error))
                }
            }
    }
   
    
}
