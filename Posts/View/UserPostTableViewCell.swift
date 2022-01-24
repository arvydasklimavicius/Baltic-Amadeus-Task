//
//  UserPostTableViewCell.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-24.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var cellViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellViewContainer.layer.cornerRadius = 8
    }
    
    func configureCell(name: String, post: String) {
        nameLabel.text = name
        postLabel.text = post
    }

}
