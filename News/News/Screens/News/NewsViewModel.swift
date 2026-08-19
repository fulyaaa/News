//
//  NewsViewModel.swift
//  News
//
//  Created by fulya akan on 29.06.2026.
//
import Foundation

protocol NewsViewModelDelegate: AnyObject {
    func didFetchArticles()
    func didFetchWithError(_ error: Error)
}

class NewsViewModel {
    
    weak var delegate: NewsViewModelDelegate?
    
    private let networkManager: NetworkManagerProtocol //protocol type, mock network manager
    private(set) var articles: [Article] = []
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchTopHeadlines() {
        networkManager.getTopHeadlines { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                DispatchQueue.main.async {
                    self?.delegate?.didFetchArticles()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.didFetchWithError(error)
                }
            }
        }
    }
    
    func numberOfArticles() -> Int {
        articles.count
    }
    
    func article(at index: Int) -> Article {
        articles[index]
    }
    
    func searchNews(query: String) {
        networkManager.searchNews(query: query) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                DispatchQueue.main.async {
                    self?.delegate?.didFetchArticles()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.didFetchWithError(error)
                }
            }
        }
    }
}
