//
//  EmployeeListTableViewCell.swift
//  Employee
//
//  Created by Sarath Krishnaswamy on 25/06/22.
//

import UIKit

class EmployeeListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var CompanyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
