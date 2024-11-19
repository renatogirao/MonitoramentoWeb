//
//  SelRast.swift
//  Monit2019
//
//  Created by Marcio Santos on 05/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

struct Rastreadores: Decodable{
    let Nome: String
}



class SelRastController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
  
    
    var courses = [Course]()
    var sEmail:String = "";
    var sSenha:String = "";

    struct Course: Decodable{
        let id: Int
        let name: String
        let link: String
    }
    
    //var arrayRast = ["France", "Brazil"]
    var arrayRast = [] as [String]
    var arraycodTel = [] as [Int]
    var arraycodPlano = [] as [Int]
    //var arrray
    
    var icodUsuarioGps:Int = 0;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number os rows in the section
        //print("NumerOfRows=", arrayRast.count)
        if arrayRast.count > 0{
            
        }
        return arrayRast.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicou em ", indexPath.row)
        
        print("arraycodTel=", arraycodPlano[indexPath.row])
        
        if(indexPath.row==0){
            return
        }
        if(arraycodPlano[indexPath.row] < 2){
            print("saindo por arraycodPlano = ", arraycodPlano[indexPath.row])
            
            showFechar(title: "O plano atual desse rastreador não permite uso via App Apple.", message: "Entre em contato para liberação", handlerOK: {action in
                print("Clicou em Fechar")
            })
                
            return
        }
        
        
        var sT: String
        sT = arrayRast[indexPath.row]
        if sT.contains("Selecione rastreador"){
            //dismiss(animated: true, completion: nil)
        }else{
            print("Else didSelect sT = ", sT)
            //ChecarStatusRast()
            UserDefaults.standard.set(sT, forKey: "Gps")
            print("salvou gps = \(sT)")
            
            /*
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let SelOpcView = mainStoryboard.instantiateViewController(withIdentifier: "SelOpcViewController") as? SelOpcViewController else {return}
            
            print("sRastreador=", arrayRast[indexPath.row])
            print("icodTel=", arraycodTel[indexPath.row-1])
            
            SelOpcView.sRastreador = arrayRast[indexPath.row]
            SelOpcView.icodTel = arraycodTel[indexPath.row-1]
            
            self.present(SelOpcView, animated: true, completion: nil)
            */
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)

            guard let Dest = mainStoryBoard.instantiateViewController(withIdentifier: "SelOpcViewController") as? SelOpcViewController else{
                print("Couldnt find the view controller")
                return
            }
            
            Dest.sRastreador = arrayRast[indexPath.row]
            Dest.icodTel = arraycodTel[indexPath.row-1]
            Dest.icodPlano = arraycodPlano[indexPath.row]
            
            print("setou icodPlano = \(Dest.icodPlano)")


            /*
            let backItem = UIBarButtonItem()
            backItem.title = "Voltar"
            self.navigationItem.backBarButtonItem = backItem
 */
            
            self.navigationController?.pushViewController(Dest, animated: true)

            
            
            
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 50
        }else{
            return 70
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        //configure the cell...
        cell.textLabel?.text = arrayRast[indexPath.row]
        //print(indexPath.row, indexPath.count)
        print("section = \(indexPath.section), row  = \(indexPath.row) adicionado : ", arrayRast[indexPath.row], " cod_plano=", arraycodPlano[indexPath.row])
        if(arrayRast[indexPath.row].contains("Selecione rastreador")){
            cell.backgroundColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = .center
        }else{
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black

        }
        
        /*
        if(indexPath.row == [tableView numberOfSections:indexPath.section]-1){
            cell.backgroundColor = UIColor.red
        }
 */
 
        //print("x=", tableView.numberOfRows)
        
        return cell
    }
    
    @IBAction func btVoltar(_ sender: Any) {
        print("Clicou em voltar")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inicio SelRast")
        
        sEmail = UserDefaults.standard.string(forKey: "Email")!
        sSenha = UserDefaults.standard.string(forKey: "Senha")!
        
        
        //tableView.register(tableView.self, forCellReuseIdentifier:"Cell")
        
        //self.title = "Selecione rastreador"
        
        icodUsuarioGps = UserDefaults.standard.integer(forKey: "codUsuarioGps")
        print("codUsuarioGps=", icodUsuarioGps, " sEmail = ", sEmail, " sSenha = ", sSenha)
        ChamarBanco()
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
 */
    
    func ChamarBanco()
    {
        
        self.arrayRast.append("Selecione rastreador")
        self.arraycodPlano.append(0)
        
        print("Inicio ChamarBanco, codUsuarioGps = ", icodUsuarioGps)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelRast"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["Mobile" : "Apple", "Email" : sEmail, "Senha" : sSenha, "codUsuarioGps" : icodUsuarioGps] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0 chamarBanco SelRast")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                        //print("P00  \(key) --- \(value)")
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                
                                if key=="Nome"{
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    self.arrayRast.append(value as! String)
                                    
                                }else if key=="cod_tel"{
                                    self.arraycodTel.append(value as! Int)
                                }else if key=="cod_plano"{
                                    self.arraycodPlano.append(value as! Int)
                                }

                            }
                        }
                    
                    }
                    
                }
                
                
 
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
                
             
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
    
    func ChecarStatusRast()
    {
        print("Inicio ChecarStatusRast, codUsuarioGps = ", icodUsuarioGps)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelRast"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["Mobile" : "Apple", "Email" : sEmail, "Senha" : sSenha, "codUsuarioGps" : icodUsuarioGps] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    //print("P00  \(key) --- \(value)")
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                
                                if key.contains("Nome"){
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    self.arrayRast.append(value as! String)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                self.arrayRast.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
    }
}
