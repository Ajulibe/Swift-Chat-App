//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Akachukwu Ajulibe on 25/07/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //--> means the corner radius is equal to the height of the cell divided by 5
        //--> this is to ensure that the radius remains proportional to the radius
        messageBubble.layer.cornerRadius = messageBubble.frame.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
