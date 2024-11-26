//
//  HistoricoComandos.swift
//  Monit2019
//
//  Created by Marcio Santos on 31/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

class HistoricoComandos: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var icodTel = 0
    var arrayHistoricoComandos = [] as [String]
    var arraySub = [] as [String]
    var sHorarioTemp = ""
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("passou cellForRowAt, indexPath = ", indexPath.row)
        let cellIdentifier = "CellComando"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = arrayHistoricoComandos[indexPath.row]
        if(arrayHistoricoComandos[indexPath.row].contains("VOLTAR")){
            cell.backgroundColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.white
        }else{
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            
        }
        
        if(indexPath.row == arraySub.count){
            cell.detailTextLabel?.text = ""
        }else{
            cell.detailTextLabel?.text = arraySub[indexPath.row] //arraySub[indexPath.row]
        }
        
        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NumerOfRows=", arrayHistoricoComandos.count)
        return arrayHistoricoComandos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sT: String
        sT = arrayHistoricoComandos[indexPath.row]
        if sT.contains("VOLTAR"){
            dismiss(animated: true, completion: nil)
        }else{
            print("Else didSelect")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == arraySub.count){
            return 50
        }else{
            return 60
        }
        
        //return 60
    }
    
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arraySub[section]
    }
 */
    
    
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inicio HistoricoComandos")
        ChamarBanco()
    }
    

    
    func ChamarBanco()
    {
        print("Inicio ChamarBanco, icodTel = ", icodTel)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelTelHistoricoComando"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["codTelHistoricoComando" : 0, "codTel" : icodTel, "codHistoricoComando" : 0, "codDevice" : 0] as [String : Any]
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
                    //print("P00  \(value)")
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        //print("is array of dicionaties")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                //print("\(i) \(key) = \(value)")
                                if key.contains("dsc"){
                                    i=i+1
                                    print("\(i) \(key) = \(value)")
                                    self.arrayHistoricoComandos.append(value as! String)
                                    print("adicionou no array ", value)
                                    
                                }else if key.contains("DtaCriacao"){
                                    
                                    //var sHorarioTemp = ""
                                    print("value=\(value)")
                                    
                                    var dateString = ""
                                    dateString = value as! String
                                    print("dateString=", dateString)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                    
                                    let date = dateFormatter.date(from: dateString)
                                    print("date = ", date ?? "")
                                    
                                    let dataNova = DateFormatter()
                                    dataNova.dateFormat = "dd/MM/yyyy HH:mm"
                                    let timeStamp = dataNova.string(from: date!)
                                    print("timeStamp=", timeStamp)
                                    
                                    self.arraySub.append(timeStamp)
                                    
                                    
                                    /*
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    let dsP = DateFormatter()
                                    //dsP.dateFormat = "dd-MM-yyyy"
                                    dsP.dateFormat = "HH:mm:ss"
                                    if let date = formatter.date(from: value as! String){
                                        print("Horario:", dsP.string(from: date))
                                        //self.Datas.append(dsP.string(from: date))
                                        self.sHorarioTemp = dsP.string(from: date)
                                    }else{
                                        print("deu merda, valor = ", value)
                                    }
                                    */
                                    
                                    /*
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    let dsP = DateFormatter()
                                    dsP.dateFormat = "HH:mm:ss"
                                    if let date = formatter.date(from: value as! String){
                                        //print("Horario:", dsP.string(from: date))
                                        //self.Datas.append(dsP.string(from: date))
                                        //sHorarioValido = "S"
                                        sHorarioTemp = dsP.string(from: date)
                                        //self.arraySub.append(dsP.string(from: date))
                                        self.arraySub.append(sHorarioTemp)
                                        print("adicionou no array sub ", sHorarioTemp)
                                    }else{
                                        print("deu merda, valor = ", value)
                                    }
                                    */
                                    
                                    //self.arraySub.append(value as! String)
                                    //print("adicionou no array sub ", value)

                                }

                                
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayHistoricoComandos.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    print("final reloadData")
                    self.tableView.reloadData()
                }
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
    
    
    
}
