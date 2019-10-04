//
//  ViewController.swift
//  dappsSwift
//
//  Created by hiroki moriguchi on 2019/10/02.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import web3swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let web3 = Web3.new(URL(string: "http://192.168.100.100:7545")!)!
        //let web3 = Web3.new(URL(string: "http://127.0.0.1:8545")!))
        
        let accounts = try! web3.eth.getAccounts()
        //print(web3.eth.getAccounts())
       print(accounts)
        var balance = try! web3.eth.getBalance(address: accounts[0])
        //print(web3.eth.getBalance(address: accounts[0]))
        print(balance.string(units: .eth))
        
    }


}

