//
//  ViewController2.swift
//  NavigationTest
//
//  Created by hiroki moriguchi on 2019/10/18.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "HyperCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        print(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        text = data[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }

    @IBOutlet weak var tableView: UITableView!
    
    var data:[String] = []
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let nextView = segue.destination as! ViewController3
            nextView.text = text
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
