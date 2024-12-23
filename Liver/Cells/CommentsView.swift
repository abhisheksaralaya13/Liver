//
//  CommentsView.swift
//  Liver
//
//  Created by Abhishek Saralaya on 23/12/24.
//


import UIKit

class CommentsView: UIView, UITableViewDataSource, UITableViewDelegate, GrowingTextViewDelegate {
    @IBOutlet weak var commentTextField: GrowingTextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var reactionView: LiverLiveReaction!

    let batchSize = 20 // Number of comments to load at a time
    var allComments: [CommentData] = [] // All 1000 comments
    var displayedComments: [CommentData] = [] // Comments currently displayed in the table
    var isLoading = false // Flag to prevent duplicate loads

    

//    override class func load() {
//        
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(commentsTableView)
        commentsTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        setupTableView()
        setupInputField()
        loadComments()
        self.bringSubviewToFront(reactionView)
    }
    
    func loadComments() {
        CommentDataManager.shared.loadCommentData(from: "MockDataForComments") { [weak self] result in
            switch result {
            case .success(let comments):
                self?.allComments = comments
                if let initialBatch = self?.allComments.suffix(self?.batchSize ?? 0) {
                    self?.displayedComments = Array(initialBatch)
                }
                DispatchQueue.main.async {
                    self?.commentsTableView.reloadData()
                    self?.scrollToBottom(animated: false)

                    
                }
                // Use the videos array in your app (e.g., pass it to a UICollectionView or UITableView)
            case .failure(let error):
                print("Failed to load videos: \(error.localizedDescription)")
            }
        }
    }
    private func setupTableView() {
        // Register the CommentsViewCell
//        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        commentsTableView.delegate = self
        commentsTableView.dataSource = self

        
        // Table view appearance
        commentsTableView.backgroundColor = .clear
        commentsTableView.isOpaque = false
        commentsTableView.separatorStyle = .none
        addGradientOverlay()
    }

    private func setupInputField() {
//        commentTextField.delegate = self
//        commentTextField.placeholder = "Add a comment..."
//        commentTextField.layer.cornerRadius = 8
//        commentTextField.clipsToBounds = true
//        commentTextField.returnKeyType = .send

        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(sendReaction), for: .touchUpInside)
    }
    
    fileprivate func configureGrowingTextView() {
        commentTextField.layer.cornerRadius = 20
        commentTextField.font = UIFont.systemFont(ofSize: 17)
        commentTextField.placeholder = NSAttributedString(string:  "Comments", attributes: [.foregroundColor: UIColor.lightGray, .font:  UIFont.systemFont(ofSize: 17) as Any])
        commentTextField.maxNumberOfLines = 5
        commentTextField.delegate = self
        likeButton.isHidden = true
        
        if #available(iOS 13.0, *) {
            let edit = UIImage(named: "send.png", in: .main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(edit, for: .normal)
            likeButton.tintColor = .clear
        } else {}
    }

    // MARK: - Actions
    @objc private func sendComment() {
        guard let text = commentTextField.text, !text.isEmpty else { return }
        let newComment = CommentData(id: Int.random(in: 1...100000), name: "You", profile_pic: "", text: text)
        allComments.append(newComment)
        displayedComments.append(newComment)
        commentTextField.text = ""
        
        // Scroll to the bottom
        DispatchQueue.main.async { [self] in
            commentsTableView.reloadData()
            scrollToNewestComment(animated: true)
        }
    }

    @objc private func sendReaction() {
        DispatchQueue.main.async { [self] in
            reactionView.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.reactionView.stopAnimation()
            })
        }
        // Handle reactions such as "like" or others here
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let reversedIndex = displayedComments.count - 1 - indexPath.row
        let comment = displayedComments[reversedIndex]
        cell.configure(with: comment)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        addGradientOverlay()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Adjust based on design
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            guard self.displayedComments.count > 0 else { return }
            let indexPath = IndexPath(row: self.displayedComments.count - 1, section: 0)
            if indexPath.row < self.commentsTableView.numberOfRows(inSection: 0) {
                self.commentsTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }


    
    func loadMoreComments() {
        guard !isLoading else { return }
        isLoading = true

        // Calculate the range of the next batch
        let start = displayedComments.count
        let end = min(start + batchSize, allComments.count)
        
        guard start < end else {
            isLoading = false
            return // No more comments to load
        }

        // Load the next batch
        let nextBatch = allComments[start..<end]
        displayedComments.append(contentsOf: nextBatch)

        // Reload the table with animation
        DispatchQueue.main.async {
            self.commentsTableView.reloadData()
            self.scrollToBottom(animated: false)
            self.isLoading = false
        }
    }

    
    private func addGradientOverlay() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1).cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.frame = commentsTableView.bounds
        commentsTableView.layer.mask = gradientLayer
    }
    
    func scrollToNewestComment(animated: Bool) {
        guard !displayedComments.isEmpty else { return }
        let indexPath = IndexPath(row: displayedComments.count - 1, section: 0)
        commentsTableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}

extension CommentsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Check if the user is near the bottom and we are not already loading
        if scrollView.contentOffset.y <= 0 {
            loadMoreComments()
        }
    }
}
