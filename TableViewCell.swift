//
//  TableViewCell.swift
//  image_load_demo
//
//  Created by Max Petrov on 02.09.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var trackLogo: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackLogo.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
