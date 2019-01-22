//
//  ViewController.swift
//  NavegadorSwift
//
//  Created by DAMN on 14/01/2019.
//  Copyright © 2019 DAMN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var url: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buscar(_ sender: Any) {
        goWeb()
    }
    @IBAction func atras(_ sender: Any) {
        web.goBack()
    }
    
    @IBAction func alante(_ sender: Any) {
        web.goForward()
    }
    
    func goWeb(){
        let aString = url.text
        let newString = aString?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        url.text = "https://google.com/search?q="+newString!
        web.loadRequest(URLRequest(url: URL(string: url.text!)!))
    }
}

