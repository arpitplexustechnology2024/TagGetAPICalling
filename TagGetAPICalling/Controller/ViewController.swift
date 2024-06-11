//
//  ViewController.swift
//  TagGetAPICalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tagsTextFiled: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tagsTextFiled.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func btnDoneTapped(_ sender: UIButton) {
        if let query = tagsTextFiled.text, !query.isEmpty {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetDataViewController") as? GetDataViewController {
                vc.query = query
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        tagsTextFiled.resignFirstResponder()
    }
    
}

