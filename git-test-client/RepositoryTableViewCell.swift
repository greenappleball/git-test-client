//
//  RepositoryTableViewCell.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/14/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireObjectMapper

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelStars: UILabel!
    @IBOutlet weak var labelForks: UILabel!
    @IBOutlet weak var labelUpdate: UILabel!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with repository: Repository) {
        self.labelName.text = repository.full_name
        self.labelDescription.text = repository.description

        let placeholderImage = UIImage(named: "first")
        let url = URL(string: (repository.owner?.avatar_url)!)!
        self.imageViewAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
}
