//
//  ViewController.swift
//  HyperDapps
//
//  Created by Michael Laurents on 2019/10/05.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import web3swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let endpoint = URL(string: "http://127.0.0.1:7545")
        let w3 = web3(provider: Web3HttpProvider(endpoint!)!)
        //print(w3.)
        print(try! w3.eth.getAccounts())
        
        let password = "web3swift"
        let key = "1885e633a2148036d1ffa5a46c96c1aefd36abcf5dacd9d6516bd99a0764febd"
        let formattedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        
        let name = "Hyper Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        //let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        let abi = get_abi()
        let contractAddress = EthereumAddress("0x2bD3EaA91CB4c3Cbc8fe05d64bed9D6DB0E67549")
        
        let contract = w3.contract(abi, at: contractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        //let from : EthereumAddress = address
        options.from = EthereumAddress(address)
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        var parameters:[AnyObject] = ["Hyper Muchos"] as! [AnyObject]
        
        var tx = contract.write("set", parameters: parameters, extraData: Data(), transactionOptions: options)
        let result = try! tx!.send(password: "test!!")
        print("result",result)
        
        
        
        
        let method = "get"
        
        var parameters2: [AnyObject] = []
        let extraData: Data = Data()
        
        var tx2 = contract.read(
        method,
        parameters: parameters2,
        extraData: extraData,
        transactionOptions: options)!
        
        var res = try! tx2.call()
        print(res)
        
    }
    
    func get_abi() -> String{
        let path = Bundle.main.path(forResource: "SimpleStorage", ofType: ".json")!
        let json_data = try! NSString( contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        let json = try! JSONSerialization.jsonObject(with: json_data.data(using: String.Encoding.utf8.rawValue)!) as! Dictionary<String, Any>
        let json_abi = try! JSONSerialization.data(withJSONObject: json["abi"]!)
        let abi = String(bytes: json_abi, encoding: .utf8)!

        return abi
    }


}

