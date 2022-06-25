//
//  ViewController.swift
//  Employee
//
//  Created by Sarath Krishnaswamy on 25/06/22.
//

import UIKit
import CoreData
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allShows = [Employee]()
    var filteredData: [Employee]!
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       //callApi()
        self.searchBar.delegate = self
        self.filteredData = allShows
        if SessionManager.sharedInstance.isDataStored{
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                //self.retrieveData()
                self.getAllShows()
                
            }
        }else{
            self.callApi()
        }
        self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            searchBar.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            searchBar.resignFirstResponder()
        }


    func callApi(){
        let params = [String:Any]()
        APiCall().get_post(to: URL(string: URL.getValues) ?? URL(fileURLWithPath: ""), params: params) { bool, response in
            //print(response)
            do{
                let decoder = JSONDecoder()
                let model = try decoder.decode([EmployeeModel].self, from: response)
                //for item in model {
                  //  print(item)
                    self.createData(model:model)
                //}
            }
            catch let error as NSError {
                self.presentAlert(withTitle: "Oops", message: error.localizedDescription)
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func createData(model:[EmployeeModel]){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        for item in model {
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(Int16(item.id ?? Int()), forKey: "id")
            user.setValue("\(item.name ?? "")", forKeyPath: "name")
            user.setValue("\(item.username ?? "")", forKeyPath: "user_name")
            user.setValue("\(item.profile_image ?? "")", forKeyPath: "profile_image")
            user.setValue("\(item.email ?? "")", forKeyPath: "email")
            
            //address
            user.setValue("\(item.address?.street ?? "")", forKeyPath: "street")
            user.setValue("\(item.address?.suite ?? "")", forKeyPath: "suite")
            user.setValue("\(item.address?.city ?? "")", forKeyPath: "city")
            user.setValue("\(item.address?.zipcode ?? "")", forKeyPath: "zipcode")
            
            
            //website
            user.setValue("\(item.website ?? "")", forKeyPath: "website")
            
            //phone
            user.setValue("\(item.phone ?? "")", forKeyPath: "phone")
            //Company Values Stored
            user.setValue("\(item.company?.name ?? "")", forKeyPath: "company_name")
            user.setValue("\(item.company?.catchPhrase ?? "")", forKeyPath: "catchPhrase")
            user.setValue("\(item.company?.bs ?? "")", forKey: "bs")
            
            //user.setValue("username\(i)", forKey: "username")
            
            //print(item.count)
            //print(user)
        }
        
        SessionManager.sharedInstance.isDataStored = true
        
        

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getAllShows()
        }
    }
    
    

    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext ?? NSManagedObjectContext()
        }
    
    
    func getAllShows() -> Array<Employee> {
           let all = NSFetchRequest<Employee>(entityName: "Employee")
           all.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
          

           do {
               let fetched = try getContext().fetch(all)
               allShows = fetched
               self.tableView.reloadData()
               //print(allShows[0].name)
           } catch {
               let nserror = error as NSError
               //TODO: Handle Error
               print(nserror.description)
           }

           return allShows
       }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            return self.filteredData.count
        }
        else{
            return self.allShows.count
        }
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListTableViewCell", for: indexPath) as! EmployeeListTableViewCell
        
        if isSearch{
            cell.profileName.text = filteredData[indexPath.row].name ?? ""
            cell.CompanyName.text = filteredData[indexPath.row].company_name ?? ""
            let fullMediaUrl = filteredData[indexPath.row].profile_image ?? ""
            cell.profileImage.kf.setImage(with:URL.init(string: fullMediaUrl) ?? URL(fileURLWithPath: "") , placeholder: UIImage(named: "dummyProfileImage"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
        }
        else{
            cell.profileName.text = allShows[indexPath.row].name ?? ""
            cell.CompanyName.text = allShows[indexPath.row].company_name ?? ""
            let fullMediaUrl = allShows[indexPath.row].profile_image ?? ""
            cell.profileImage.kf.setImage(with:URL.init(string: fullMediaUrl) ?? URL(fileURLWithPath: "") , placeholder: UIImage(named: "dummyProfileImage"), options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch{
            print(filteredData[indexPath.row])
            let vc = storyboard?.instantiateViewController(withIdentifier: "EmployeeDetailViewController") as! EmployeeDetailViewController
            vc.profileImage = filteredData[indexPath.row].profile_image ?? ""
            vc.name = filteredData[indexPath.row].name ?? ""
            vc.userName = filteredData[indexPath.row].user_name ?? ""
            vc.email = filteredData[indexPath.row].email ?? ""
            let address = "\(filteredData[indexPath.row].street ?? ""),\(filteredData[indexPath.row].suite ?? ""), \n\(filteredData[indexPath.row].city ?? "" ), \(filteredData[indexPath.row].zipcode ?? "")"
            vc.address = address
            vc.phone = filteredData[indexPath.row].phone ?? ""
            vc.website = filteredData[indexPath.row].website ?? ""
            let companyDetails = "\(filteredData[indexPath.row].name ?? "")\n\(filteredData[indexPath.row].catchPhrase ?? "")\n\(filteredData[indexPath.row].bs ?? "")"
            vc.coampany_details = companyDetails
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            print(allShows[indexPath.row])
            let vc = storyboard?.instantiateViewController(withIdentifier: "EmployeeDetailViewController") as! EmployeeDetailViewController
            vc.profileImage = allShows[indexPath.row].profile_image ?? ""
            vc.name = allShows[indexPath.row].name ?? ""
            vc.userName = allShows[indexPath.row].user_name ?? ""
            let address = "\(allShows[indexPath.row].street ?? ""),\(allShows[indexPath.row].suite ?? ""), \n\(allShows[indexPath.row].city ?? "" ), \(allShows[indexPath.row].zipcode ?? "")"
            vc.address = address
            vc.email = allShows[indexPath.row].email ?? ""
            vc.phone = allShows[indexPath.row].phone ?? ""
            vc.website = allShows[indexPath.row].website ?? ""
            let companyDetails = "\(allShows[indexPath.row].name ?? "")\n\(allShows[indexPath.row].catchPhrase ?? "")\n\(allShows[indexPath.row].bs ?? "")"
            vc.coampany_details = companyDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.count > 0{
            filteredData = allShows.filter{ $0.name?.range(of: searchText, options: .caseInsensitive) != nil || $0.email?.range(of: searchText, options: .caseInsensitive) != nil }
            //filteredData = allShows.filter{ $0.email?.range(of: searchText, options: .caseInsensitive) != nil }
            self.isSearch = true
            self.tableView.reloadData()
        }
        else{
            self.isSearch = false
            self.tableView.reloadData()
        }
        
        
    
    }
    
}
