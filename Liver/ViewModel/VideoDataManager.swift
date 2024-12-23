//
//  VideoDataManager.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//


import Foundation

// MARK: - Video Data Manager
class VideoDataManager {
    // Singleton instance
    static let shared = VideoDataManager()
    
    private init() {}
    
    // Array to hold video data
    private var videos: [VideoData] = []
    
    // Load video data from JSON file
    func loadVideoData(from filename: String, completion: @escaping (Result<[VideoData], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found."])))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decodedVideos = try JSONDecoder().decode([String:[VideoData]].self, from: data)
            if let decodedVideos = decodedVideos["videos"] {
                self.videos = decodedVideos
            }
            completion(.success(self.videos))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Get video data
    func getVideos() -> [VideoData] {
        return videos
    }
}
