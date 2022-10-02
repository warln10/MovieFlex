//
//  APICaller.swift
//  MovieFlex
//
//  Created by Warln on 20/03/22.
//

import UIKit

class APICaller {
    
    static let shared = APICaller()
    
    enum ApiError: Error {
        case throwError
    }
    
    func getTrendingMovie(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURl)3/trending/movie/day?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURl)3/trending/tv/day?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURl)3/movie/popular?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getUpComing(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURl)3/movie/upcoming?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURl)3/movie/top_rated?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getDiscover(completion: @escaping (Result<[Title],Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.baseURl)3/discover/movie?api_key=\(Constant.Api_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }
            catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    
    func getSearch(with quary: String, completion: @escaping (Result<[Title],Error>) -> Void) {
        guard let quary = quary.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constant.baseURl)3/search/movie?api_key=\(Constant.Api_Key)&query=\(quary)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,error == nil  else{
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(MovieTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
    func getYoutube(with quary: String, completion: @escaping (Result<Item,Error>) -> Void) {
        //GET https://youtube.googleapis.com/youtube/v3/search?q=harry%20potter&key=
        guard let quary = quary.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(Constant.youtube_BaseUrl)q=\(quary)&key=\(Constant.youtube_Api_key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result =  try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(result.items[0]))
            }catch{
                completion(.failure(ApiError.throwError))
            }
        }
        task.resume()
    }
    
}
