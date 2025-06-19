//
//  ReviewsViewController.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import UIKit
import SnapKit

class ReviewsViewController: UITableViewController {
    
    private let reviews: [ProductReview]
    
    init(reviews: [ProductReview]) {
        self.reviews = reviews
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "ReviewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        let review = reviews[indexPath.row]
        let rating = review.rating ?? 0
        let comment = review.comment ?? ""
        let reviewer = review.reviewerName ?? ""
        let dateString = review.date ?? ""
        cell.ratingLabel.text = "評分：\(rating) ★"
        cell.commentLabel.text = comment
        cell.reviewerLabel.text = "by \(reviewer)"
        cell.dateLabel.text = dateString
        return cell
    }
}
