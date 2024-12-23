//
//  VideoFeedViewController.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//


import UIKit

class VideoFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var videos: [VideoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        VideoDataManager.shared.loadVideoData(from: "MockDataForVideos") { result in
            switch result {
            case .success(let videos):
                print("Loaded \(videos.count) videos.")
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                // Use the videos array in your app (e.g., pass it to a UICollectionView or UITableView)
            case .failure(let error):
                print("Failed to load videos: \(error.localizedDescription)")
            }            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let videoData = videos[indexPath.row]
        cell.configure(with: videoData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
