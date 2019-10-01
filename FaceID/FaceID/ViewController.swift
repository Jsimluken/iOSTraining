//
//  ViewController.swift
//  FaceID
//
//  Created by hiroki moriguchi on 2019/09/30.
//  Copyright © 2019年 Michael Laurents. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.backgroundColor = .red
        
        
        
        attemptLogin()
        
        // Do any additional setup after loading the view, typically from a nib.
        /*context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason, reply: { success, error in return .faceid })*/
    }

    
    func attemptLogin()  {
        let context = LAContext()
        var error :NSError?
        let reason = "Log in to your account"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            print("OK!!")
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    //self.label.text! = "Logged in"
                    print("Yatta!!")
                    //label.backgroundColor! = .green
                    DispatchQueue.main.async{
                        print("success!!")
                        self.label.backgroundColor = .green
                        self.label.text = "Loged in!!"
                    }
                }
                else{
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    return
                }
            }
        }else{
            print("Bikkuri",error)
            return
        }
    }
        
}

