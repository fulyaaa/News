//
//  NewsDetailViewController.swift
//  News
//
//  Created by fulya akan on 23.06.2026.
//

import UIKit
import Kingfisher

class NewsDetailViewController: UIViewController {
    
    var article: Article?
    
    private let scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
    
    private let contentView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
    
    private let newsImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.backgroundColor = .secondarySystemBackground
           iv.translatesAutoresizingMaskIntoConstraints = false
           return iv
       }()
       
       private let contentLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 16, weight: .regular)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                setupViews()
                setupNavigationBar()
                configure()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = article?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func setupViews() {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(newsImageView)
            contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
                    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    
                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    
                    newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    newsImageView.heightAnchor.constraint(equalToConstant: 250),
                    
                    contentLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16),
                    contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
                ])
            }
            
            private func configure() {
                guard let article = article else { return }
                
                contentLabel.text = article.content ?? article.description ?? NSLocalizedString("no_content", comment: "")
                
                if let urlString = article.urlToImage, let url = URL(string: urlString) {
                    newsImageView.kf.setImage(with: url)
                }
            }
            
            @objc private func shareTapped() {
                guard let urlString = article?.url, let url = URL(string: urlString) else { return }
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                present(activityVC, animated: true)
            }
        }
