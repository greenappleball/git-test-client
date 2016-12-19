//
//  RepositoryTableViewCell.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/14/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import AlamofireImage

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelStars: UILabel!
    @IBOutlet weak var labelForks: UILabel!
    @IBOutlet weak var labelUpdate: UILabel!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    static let network = NetworkService()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with repository: Repository) {
        self.labelName.text = repository.fullName
        self.labelDescription.text = repository.description

        RepositoryTableViewCell.network.loadDetails(for: repository) { repository in
            self.labelStars.text = "\(repository.stargazersCount)"
            self.labelForks.text = "\(repository.forksCount)"
            self.labelLanguage.text = repository.language
            self.labelUpdate.text = repository.updatedOn
        }

        let placeholderImage = UIImage(named: "first")
        let url = URL(string: (repository.owner?.avatarUrl)!)!
        self.imageViewAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
}
