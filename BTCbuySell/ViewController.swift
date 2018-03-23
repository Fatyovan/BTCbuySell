//
//  ViewController.swift
//  BTCbuySell
//
//  Created by KorvMac01 on 20.3.18.
//  Copyright © 2018 Ivan Jovanovik. All rights reserved.
//

import UIKit 
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    var total:Double = 0;
    var totalSell:Double = 0;
    @IBOutlet weak var bitcoinPriceEur: UILabel!
    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var amountSell: UITextField!
    @IBOutlet weak var priceSell: UITextField!
    @IBOutlet weak var amountBuy: UILabel!
    @IBOutlet weak var priceBuy: UITextField!
    @IBOutlet weak var btcProfit: UILabel!
    @IBOutlet weak var usdProfit: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    static let kBPI = "bpi"
    static let kUSD = "USD"
    static let kEUR = "EUR"
    static let kRATE = "rate_float"

    @IBOutlet weak var transactionFee: UITextField!
    @IBAction func reloadBTCPrice(_ sender: UIButton) {
        getBitcoinPrice()
        sender.pulsate()
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {

        let bitcoinPriceFloat2 = (bitcoinPrice.text! as NSString).floatValue
    
        totalSell = Double(Double(amountSell.text!)! * Double(priceSell.text!)!)
        let amountBuyPom : Double = totalSell / Double(priceBuy.text!)!
        amountBuy.text = ("\(String(totalSell / Double(priceBuy.text!)!)) BTC")
        let btcProfitPom : Float = Float(amountBuyPom - Double(amountSell.text!)!)
        btcProfit.text = ("\(amountBuyPom - Double(amountSell.text!)!) BTC")
                usdProfit.text = ("\(String(btcProfitPom * bitcoinPriceFloat2)) USD")
            
            
                sender.pulsate()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        getBitcoinPrice()
    }
    
    func getBitcoinPrice(){
        Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseJSON{ response in
            print(response)
            if let bitcoinJSON = response.result.value{
                let bitcoinObject:Dictionary = bitcoinJSON as! Dictionary<String, Any>
                
                let bpiObject:Dictionary = bitcoinObject[ViewController.kBPI] as! Dictionary<String, Any>
                let usdObject:Dictionary = bpiObject[ViewController.kUSD] as! Dictionary<String, Any>
                let rateUSD:Double = usdObject[ViewController.kRATE] as! Double
                let rateFloatUSD:Double = rateUSD
                
                self.bitcoinPrice.text = (" \(rateFloatUSD) $")
                
                let eurObject:Dictionary = bpiObject[ViewController.kEUR] as! Dictionary<String, Any>
                let rateEUR:Double = eurObject[ViewController.kRATE] as! Double
                let rateFloatEUR:Double = rateEUR
                
                self.bitcoinPriceEur.text = (" \(rateFloatEUR) €")
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
        if (amountBuy.text != "") {
            amountSell.text = ""
            priceSell.text = ""
            priceBuy.text = ""
            amountBuy.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }

}
//extension MainViewController: CGFloat {
//    var decimalsClean: String {
//        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
//    }
//}

