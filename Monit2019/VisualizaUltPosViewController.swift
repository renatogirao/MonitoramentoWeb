//
//  VisualizaUltPosViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 19/07/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import UIKit

class VisualizaUltPosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableView: UITableView!
    
    let data = ["data 1","2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var arrayCoordenada = [] as [String]
    var arrayVelocidadeKM = [] as [String]
    var arrayData = [] as [String]
    var icodTel = UserDefaults.standard.integer(forKey: "codTel")
    var sLat = "" as String
    var sLong = "" as String
    var iQTD = 0 as Int
    var sRastreador = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
        print("Inicio VisualizaUltPosViewController icodTel = ", icodTel)
        ChamarBanco()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row==0){
            return
        }
        print("Coordenada clicada=", arrayCoordenada[indexPath.row])
        
        //let s = arrayCoordenada[indexPath.row]
        //let b = s.replacingOccurrences(of: "Coordenada: ", with: "")
        
        UIPasteboard.general.string = arrayCoordenada[indexPath.row].replacingOccurrences(of: "Coordenada: ", with: "")
        ME(userMessage: "Coordenada copiada para memória");

    }
    
    func ME(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Mensagem:", message: userMessage, preferredStyle: .alert);
        
        let okACtion = UIAlertAction(title:"Fechar", style: .default, handler:nil)
        
        myAlert.addAction(okACtion)
        
        
        present(myAlert, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCoordenada.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TableViewCellUltPos
        
        print("Inicio VisualizaUltPosViewController indexPath.row = ", indexPath.row)
        print("Inicio VisualizaUltPosViewController arrayCoordenada.count = ", arrayCoordenada.count)
        
        cell.lblCoordenada.text = arrayCoordenada[indexPath.row]
        cell.lblHorario.text = arrayData[indexPath.row]
        cell.lblVelocidade.text = String(arrayVelocidadeKM[indexPath.row])
        
        if(arrayCoordenada[indexPath.row].contains("Clique sobre a coordenada")){
            cell.backgroundColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = .center
            cell.lblCoordenada.textColor = UIColor.white
            cell.lblCoordenada.textAlignment = .center
            cell.lblHorario.textColor = UIColor.white
            cell.lblHorario.textAlignment = .center
            cell.lblHorario?.text = "(" + sRastreador + ")"
        }else{
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }

        //configure the cell...
        //cell.textLabel?.text = arrayCoordenada[indexPath.row]
        //print(indexPath.row, indexPath.count)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 50
        }else{
            return 70
        }    }
    
    

    
    func ChamarBanco()
    {
        
        self.arrayCoordenada.append("Clique sobre a coordenada")
        self.arrayVelocidadeKM.append("")
        self.arrayData.append("")
        
        print("Inicio ChamarBanco, icodTel = ", icodTel)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/TB9000"
        
        var sHorario = "" as String
        var iKM = 0 as Double
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["Cod9000" : "", "Data" : "", "Imei" : "", "codTel" : icodTel] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0 chamarBanco TB9000")
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
                                
                                if(self.iQTD==0){
                                    self.sLat = ""
                                    self.sLong = ""
                                }
                                
                                if key=="lat"{
                                    print("\(i) \(key) = \(value)")
                                    i=i+1
                                    self.iQTD = self.iQTD + 1
                                    print("\(i) \(key) = \(value) QTD = \(self.iQTD)")
                                    //self.arrayCoordenada.append(value as! String)
                                    self.sLat = value as! String
                                }else if key=="long"{
                                    self.iQTD = self.iQTD + 1
                                    print("\(i) \(key) = \(value) QTD = \(self.iQTD)")
                                    self.sLong = value as! String
                                }else if key=="speedKM"{
                                    self.iQTD = self.iQTD + 1
                                    print("\(i) \(key) = \(value) QTD = \(self.iQTD)")
                                    iKM = value as! Double
                                    self.arrayVelocidadeKM.append("Velocidade: \(String(iKM)) km/h")
                                }else if key=="DtaBR"{
                                    self.iQTD = self.iQTD + 1
                                    print("\(i) \(key) = \(value) QTD = \(self.iQTD)")
                                    //print("\(i) \(key) = \(value)")
                                    sHorario = value as! String
                                    self.arrayData.append("Horário: " + sHorario)
                                }
                                
                                if(self.iQTD == 4)
                                {
                                    self.arrayCoordenada.append("Coordenada: " + self.sLat + ", " + self.sLong)
                                    self.iQTD = 0
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                
                DispatchQueue.main.sync {
                    self.TableView.reloadData()
                }
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
 

    
}
