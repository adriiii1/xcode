//
//  ViewController2.swift
//  NavegadorSwift
//
//  Created by DAMN on 22/01/2019.
//  Copyright © 2019 DAMN. All rights reserved.
//

import UIKit
import SQLite3

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var historial: [String] = []
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historial.removeAll()
        
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

        let queryString = "SELECT * FROM Historial"
  
        var stmt:OpaquePointer?

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error al preparar SQL: \(errmsg)")
            return
        }

        while(sqlite3_step(stmt) == SQLITE_ROW){
            let url = String(cString: sqlite3_column_text(stmt, 1))
    
            historial.append(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historial.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "registro")
        cell.textLabel?.text  = historial[indexPath.row]
        return cell
    }
    @IBAction func salir(_ sender: Any) { self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
