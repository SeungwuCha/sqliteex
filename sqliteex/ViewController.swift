//
//  ViewController.swift
//  sqliteex
//
//  Created by seungwoo seoul on 2017. 11. 4..
//  Copyright © 2017년 seungwoo seoul. All rights reserved.
// 참고 : https://youtu.be/c4wLS9py1rU

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var database: Connection!
    
    let userTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl =  documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch{
            print(error)
        }
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectData(_ sender: Any) {
        do{
            let users = try self.database.prepare(self.userTable)
            for user in users {
                print("userid : \(user[self.id]), name : \(user[self.name]), email : \(user[self.email])")
            }
           
        }catch{
            print(error)
        }
    }
    @IBAction func insertItem(_ sender: Any) {
        let alert = UIAlertController(title:"Insert User", message:nil, preferredStyle: .alert)
        alert.addTextField{(tf) in tf.placeholder = "Name"}
        alert.addTextField{(tf) in tf.placeholder = "Email"}
        let action = UIAlertAction(title: "Submit", style: .default){(_) in
            guard let name = alert.textFields?.first?.text,
            let email = alert.textFields?.last?.text
            else{return}
            print(name)
            print(email)
            
            let insertUser = self.userTable.insert(self.name <- name,self.email <- email)
            
            do{
                try self.database.run(insertUser)
                print("Inserted User")
            }catch{
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func updateData(_ sender: Any) {
        let alert = UIAlertController(title:"Update User", message:nil, preferredStyle: .alert)
        alert.addTextField{(tf) in tf.placeholder = "User ID"}
        alert.addTextField{(tf) in tf.placeholder = "Email"}
        let action = UIAlertAction(title: "Submit", style: .default){(_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString),
                let email = alert.textFields?.last?.text
                else{return}
            print(userIdString)
            print(email)
            
            
            let user = self.userTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
           // let updateUser = self.userTable.update(self.email <- email)
            
            do{
                try self.database.run(updateUser)
                print("updated User")
            }catch{
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteData(_ sender: Any) {
        let alert = UIAlertController(title:"Delete User", message:nil, preferredStyle: .alert)
        alert.addTextField{(tf) in tf.placeholder = "User ID"}
        
        let action = UIAlertAction(title: "Submit", style: .default){(_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString)
                else{return}
            print(userIdString)
            
            
            
            let user = self.userTable.filter(self.id == userId)
            
            let deleteUser = user.delete();
            // let updateUser = self.userTable.update(self.email <- email)
            
            do{
                try self.database.run(deleteUser)
                print("Delete User")
            }catch{
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func createtable(_ sender: Any) {
        print("create table")
        
        let createTable = self.userTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique:true)
        }
        do{
            try self.database.run(createTable)
            print("Created Table")
        }catch{
            print(error)
        }
        
    }


}

