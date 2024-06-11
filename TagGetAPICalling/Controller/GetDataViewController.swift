//
//  GetDataViewController.swift
//  TagGetAPICalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit
import Alamofire

class GetDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var query : String?
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        guard let userInput = query else {
            print("Name value is missing")
            return
        }
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "e103305047msh67c54e4389f5e37p106668jsn6f55a35f4271",
            "Accept": "application/json"
        ]
        
        let apiUrl = "https://tags-generator.p.rapidapi.com/youtubeTags/\(userInput)"
        
        AF.request(apiUrl, headers: headers).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(Welcome.self, from: jsonData)
                    self.items = responseData.data.tags
                    self.tableView.reloadData()
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}

// MARK: - TableView Dalegate & Datasource
extension GetDataViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell") as! TagTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
            cell.tagsLbl.text = items[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        } else {
            return 44
        }
    }
}
