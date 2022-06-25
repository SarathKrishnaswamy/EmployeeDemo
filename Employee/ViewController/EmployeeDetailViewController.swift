//
//  EmployeeDetailViewController.swift
//  Employee
//
//  Created by Sarath Krishnaswamy on 25/06/22.
//

import UIKit
import Kingfisher

class EmployeeDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var profileImage = ""
    var name = ""
    var userName = ""
    var email = ""
    var address = ""
    var phone = ""
    var website = ""
    var coampany_details = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}


extension EmployeeDetailViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailTableViewCell", for: indexPath) as! EmployeeDetailTableViewCell
        let fullMediaUrl = profileImage
        cell.profileImage.kf.setImage(with:URL.init(string: fullMediaUrl) ?? URL(fileURLWithPath: "") , placeholder: UIImage(named: "dummyProfileImage"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
        cell.profileNameLbl.text = name
        cell.profileUserNameLbl.text = userName
        cell.emailAddressLbl.text = email
        cell.addressLbl.text = address
        cell.phoneLbl.text = phone
        cell.websiteLbl.text = website
        cell.companyDetailsLbl.text = coampany_details
        return cell
    }
    
    
}
