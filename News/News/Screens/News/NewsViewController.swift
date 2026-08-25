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
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        viewModel.delegate = self
        viewModel.fetchTopHeadlines()
        
        tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
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
        cell.moreButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let shareAction = UIAlertAction(title: "Haberi Paylaş", style: .default) { _ in
                if let url = URL(string: article.url) {
                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    self.present(activityVC, animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
            
            sheet.addAction(shareAction)
            sheet.addAction(cancelAction)
            
            self.present(sheet, animated: true)
        }
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let article = viewModel.article(at: indexPath.item)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        detailVC.article = article
        
        navigationController?.pushViewController(detailVC, animated: true)
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

extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            viewModel.fetchTopHeadlines()
            return
        }
        
        if query.count > 3 {
            viewModel.searchNews(query: query)
        }
    }
}
