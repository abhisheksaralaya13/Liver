//
//  VideoDataManager 2.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//

import Foundation

// MARK: - Comment Data Manager
class CommentDataManager {
    // Singleton instance
    static let shared = CommentDataManager()
    
    private init() {}
    
    // Array to hold Comment data
    private var comments: [CommentData] = []
    
    // Load video data from JSON file
    func loadCommentData(from filename: String, completion: @escaping (Result<[CommentData], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found."])))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decodedComments = try JSONDecoder().decode([CommentData].self, from: data)
                self.comments = decodedComments
            completion(.success(self.comments))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Get video data
    func getVideos() -> [CommentData] {
        return comments
    }
}
