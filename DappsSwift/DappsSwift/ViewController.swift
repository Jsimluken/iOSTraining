//
//  ViewController.swift
//  DappsSwift
//
//  Created by Michael Laurents on 2019/10/03.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import web3swift
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let web3 = Web3.new(URL(string: "http://127.0.0.1:7545")!)!
        let path = Bundle.main.path(forResource: "SimpleStorage", ofType: ".json")!
        // Do any additional setup after loading the view.
        print(path)
        let json_data = try! NSString( contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        let json = try! JSONSerialization.jsonObject(with: json_data.data(using: String.Encoding.utf8.rawValue)!) as! Dictionary<String, Any>
        
        print(try! web3.eth.getAccounts())
        print(json["abi"])
        let contractAddress = Address("0x8c8bDB2E7Aa55ec86E708607487b45fA92D57B74")
        let abi = json["abi"] as! String
        let contract = try !web3.contract(abi, at: contractAddress)
        //web3.con
        print(contract)
    }


}

