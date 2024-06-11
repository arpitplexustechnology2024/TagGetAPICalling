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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var noInternetView: NoInternetView!
    var noDataView: NoDataView!
    var query : String?
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        
        setupNoInternetView()
        setupNoDataView()
        
        if let query = query {
            if isConnectedToInternet() {
                showLoaderAndFetchData(query: query)
            } else {
                showNoInternetView()
            }
        }
        
    }
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noDataView.isHidden = true
    }
    
    @objc func retryButtonTapped() {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            showLoaderAndFetchData(query: query!)
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    
    func showLoaderAndFetchData(query: String) {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.searchGitHubUsers(userInput: query)
        }
    }
    
    func searchGitHubUsers(userInput: String) {
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
                    if self.items.isEmpty {
                        self.showNoDataView()
                    } else {
                        self.noDataView.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func showNoDataView() {
        noDataView.isHidden = false
        tableView.isHidden = true
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    func showNoInternetView() {
        noInternetView.isHidden = false
        activityIndicator.stopAnimating()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTranform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTranform
        cell.alpha = 1.0
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    
}
