//
//  CommentsViewCell.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//

import UIKit
class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configure(with comment: CommentData) {
        usernameLabel.text = comment.name
        commentLabel.text = comment.text
        
        if let url = URL(string: comment.profile_pic) {
            loadImage(from: url) { image in
                self.profileImageView.image = image
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
