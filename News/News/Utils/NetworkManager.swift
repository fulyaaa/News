//
//  NetworkManager.swift
//  News
//
//  Created by fulya akan on 24.06.2026.
//
import Foundation

protocol NetworkManagerProtocol {
    func getTopHeadlines(completion: @escaping (Result<[Article], Error>) -> Void)
    func searchNews(query: String, completion: @escaping (Result<[Article], Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private let apiKey = "daff04363a184a4488bd59e2b6ce9fd0"
    private let baseURL = "https://newsapi.org/v2/"
    
    func getTopHeadlines(completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = ("\(baseURL)top-headlines?country=us&apiKey=\(apiKey)")
        performRequest(urlString: urlString, completion: completion)
    }
    
    func searchNews(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = "\(baseURL)/everything?q=\(query)&apiKey=\(apiKey)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    private func performRequest(urlString: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(ArticleResponse.self, from: data)
                completion(.success(result.articles))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
