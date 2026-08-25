//
//  NewsCell.swift
//  News
//
//  Created by fulya akan on 30.06.2026.
//

import UIKit
import Kingfisher

class NewsCell: UICollectionViewCell {
    
    static let identifier: String = "NewsCell"
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal   )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var moreButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func setupViews() {
            contentView.addSubview(newsImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(authorLabel)
            contentView.addSubview(dateLabel)
            contentView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
                   newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                   newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                   newsImageView.widthAnchor.constraint(equalToConstant: 100),
                   
                   titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
                   titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                   titleLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -8),
                   
                   authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                   authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                   authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                   
                   dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                               dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                               
                               moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                               moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                               moreButton.widthAnchor.constraint(equalToConstant: 30),
                               moreButton.heightAnchor.constraint(equalToConstant: 30)
                           ])
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
                       }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        authorLabel.text = article.author ?? article.source.name
        dateLabel.text = formatDate(article.publishedAt)
        
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            newsImageView.kf.setImage(with: url)
        } else {
            newsImageView.image = UIImage(systemName: "newspaper")
        }
    }
       
       private func formatDate(_ dateString: String) -> String {
           let formatter = ISO8601DateFormatter()
           guard let date = formatter.date(from: dateString) else { return "" }
           
           let now = Date()
           let diff = now.timeIntervalSince(date)
           
           if diff < 3600 {
                      return "\(Int(diff / 60))m ago"
                  } else if diff < 86400 {
                      return "\(Int(diff / 3600))h ago"
                  } else {
                      return "\(Int(diff / 86400))d ago"
                  }
              }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        moreButtonTapped?()
    }
}
