import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    static let identifier = "VideoCell"
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsView: CommentsView!
//    @IBOutlet weak var commentTextField: UITextField!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    
    func configure(with videoData: VideoData) {
        self.commentsView.backgroundColor = .clear
        usernameLabel.text = videoData.username
        viewersLabel.text = "\(videoData.viewers) viewers"
        likesLabel.text = "\(videoData.likes) likes"
//        commentsView.
        
        if let url = URL(string: videoData.profilePicURL) {
            // Use a library like SDWebImage for async image loading.
            loadImage(from: url, into: profileImageView)
        }
        
        setupVideoPlayer(with: videoData.video)
    }
    
    private func setupVideoPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer!)
        
        player?.play()
        player?.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        videoView.bringSubviewToFront(commentsView)
        videoView.bringSubviewToFront(profileImageView)
        videoView.bringSubviewToFront(usernameLabel)
        videoView.bringSubviewToFront(likesLabel)
    }
    
    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        // Simulate an async image load (replace with a real library like SDWebImage in production)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
