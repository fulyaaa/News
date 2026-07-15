//
//  Article.swift
//  News
//
//  Created by fulya akan on 24.06.2026.
//
import Foundation

struct ArticleResponse: Codable, Sendable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable, Sendable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable, Sendable {
    let id: String?
    let name: String
}
