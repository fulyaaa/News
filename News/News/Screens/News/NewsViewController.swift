//
//  NewsViewController.swift
//  News
//
//  Created by fulya akan on 23.06.2026.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let viewModel = NewsViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 100)
        layout.minimumLineSpacing = 12
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        title = "News"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        viewModel.delegate = self
        print("Calling fetchTopHeadlines")
        viewModel.fetchTopHeadlines()
    }
}
  
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfArticles()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        let article = viewModel.article(at: indexPath.item)
        cell.configure(with: article)
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // İleride: News Detail ekranına geçiş buraya gelecek
    }
}

extension NewsViewController: NewsViewModelDelegate {
    func didFetchArticles() {
        collectionView.reloadData()
    }
    
    func didFetchWithError(_ error: Error) {
        print("Error fetching articles: \(error.localizedDescription)")
    }
}
