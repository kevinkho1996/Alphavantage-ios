//
//  StockViewController.swift
//  AlphavantageIos
//
//  Created by Kevin Kho on 25/10/20.
//

import UIKit

class StockViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabels()
        
        self.searchField.delegate = self
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        getStockData()
//        dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getStockData()
        self.view.endEditing(true)
        return false
    }
    
    func getStockData() {
        let session = URLSession.shared
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(searchField.text ?? "")&interval=5min&apikey=BAFWHCGZP2PA93QF")!
        
        let dataTask = session.dataTask(with: quoteURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let data = data {
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let quoteDictionary = jsonObj.value(forKey: "Global Quote") as? NSDictionary {
                            DispatchQueue.main.async {
                                if let symbol = quoteDictionary.value(forKey: "01. symbol") {
                                    self.symbolLabel.text = symbol as? String
                                }
                                if let open = quoteDictionary.value(forKey: "02. open") {
                                    self.openLabel.text = open as? String
                                }
                                if let high = quoteDictionary.value(forKey: "03. high") {
                                    self.highLabel.text = high as? String
                                }
                                if let low = quoteDictionary.value(forKey: "04. low") {
                                    self.lowLabel.text = low as? String
                                }
                                if let time = quoteDictionary.value(forKey: "07. latest trading day") {
                                    self.timeLabel.text = time as? String
                                }
                            }
                        } else {
                            print("Error: unable to find quote")
                            DispatchQueue.main.async {
                                self.resetLabels()
                            }
                        }
                    } else {
                        print("Error: failed to convert data")
                        DispatchQueue.main.async {
                            self.resetLabels()
                        }
                    }
                } else {
                    print("Error: failed to receive data")
                    DispatchQueue.main.async {
                        self.resetLabels()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func resetLabels() {
        symbolLabel.text = ""
        openLabel.text = ""
        highLabel.text = ""
        lowLabel.text = ""
        timeLabel.text = ""
    }
    
//    @objc func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
}
