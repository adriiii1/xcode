//
//  ViewController.swift
//  NavegadorSwift
//
//  Created by DAMN on 14/01/2019.
//  Copyright © 2019 DAMN. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    var db: OpaquePointer?
    
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var url: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Historial.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error al abrir la base de datos")
        }
        else {
            print("Conectado")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Historial (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error al crear la tabla: \(errmsg)")
            }
        }
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
        
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Historial (url) VALUES ('"+url.text!+"')"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error al preparar SQL: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error al insertar: \(errmsg)")
            return
        }
        
        web.loadRequest(URLRequest(url: URL(string: url.text!)!))
    }
}

