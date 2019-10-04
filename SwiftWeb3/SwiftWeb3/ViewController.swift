//
//  ViewController.swift
//  SwiftWeb3
//
//  Created by hiroki moriguchi on 2019/10/04.
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
        let key = "3bb2ddd0c56e0f8d355abd6b3908bc88847ab8aa2940951a5aed7f9528990a38"
        let formattedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        
        let name = "Hyper Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        //let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        let abi = get_abi()
        let contractAddress = EthereumAddress("0xE17c8FF46904Ba2f640Eefec375B06A1C7067D1c")
        
        let contract = w3.contract(abi, at: contractAddress, abiVersion: 2)!
        var options = TransactionOptions.defaultOptions
        //let from : EthereumAddress = address
        options.from = EthereumAddress(address)
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        var parameters:[AnyObject] = ["Muchos"] as! [AnyObject]
        
        var tx = contract.write("set", parameters: parameters, extraData: Data(), transactionOptions: options)
        let result = try! tx!.send(password: password)
        
        
        
        
        
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
        
        
       // print(wallet.)
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

