//
//  VisMapFiltroViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 15/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

class VisMapFiltroViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var sDtaInicio = ""
    var sDtaFim = ""
    var iQTD = 0

    
    var Datas = [String]()
    var Datascod = [Int]()
    var Hora = [String]()
    var Minuto = [String]()
    
    var ArrayCoordenadas = [String]()
    var ArrayHorarioCoordenadas = [String]()
    
    var codData: Int = 0
    
    var icodTel = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtData{
            //print("numberOfRos = ", dados.count)
            return Datas.count
        }else if currentTextField == txtHoraInicio{
            return Hora.count
        }else if currentTextField == txtMinutoInicio{
            return Minuto.count
        }else if currentTextField == txtHoraFim{
            return Hora.count
        }else if currentTextField == txtMinutoFim{
            return Minuto.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtData{
            return Datas[row]
        }else if currentTextField == txtHoraInicio{
            return Hora[row]
        }else if currentTextField == txtMinutoInicio{
            return Minuto[row]
        }else if currentTextField == txtHoraFim{
            return Hora[row]
        }else if currentTextField == txtMinutoFim{
            return Minuto[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == txtData{
            txtData.text = Datas[row]
            codData = Datascod[row]
            //print("adicionou ", dados[row])

        }else if currentTextField == txtHoraInicio{
            txtHoraInicio.text = Hora[row]
        }else if currentTextField == txtMinutoInicio{
            txtMinutoInicio.text = Minuto[row]
        }else if currentTextField == txtHoraFim{
            txtHoraFim.text = Hora[row]
        }else if currentTextField == txtMinutoFim{
            txtMinutoFim.text = Minuto[row]
        }
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == txtData{
            currentTextField.inputView = pickerView
        }else if currentTextField == txtHoraInicio{
            /*
            if txtData.text!.isEmpty{
                print("vazio")
                //return false
            }else{
                currentTextField.inputView = pickerView
            }*/
            currentTextField.inputView = pickerView
        }else if currentTextField == txtMinutoInicio{
            currentTextField.inputView = pickerView
        }else if currentTextField == txtHoraFim{
            currentTextField.inputView = pickerView
        }else if currentTextField == txtMinutoFim{
            currentTextField.inputView = pickerView
        }
        //return true
    }
    
    

    
    
    
    @IBOutlet weak var txtData: UITextField!
    @IBOutlet weak var txtHoraInicio: UITextField!
    @IBOutlet weak var txtMinutoInicio: UITextField!
    @IBOutlet weak var txtHoraFim: UITextField!
    @IBOutlet weak var txtMinutoFim: UITextField!
    @IBAction func BTPesquisar(_ sender: Any) {
        print("Clicou pesquisar VisMapFiltroViewController")
        
        UserDefaults.standard.set("S", forKey: "VisMapFiltro")
        //self.tabBarController?.selectedIndex = 0
        
        
        
        
        if txtData.text?.isEmpty ?? true{
            self.ME(userMessage: "Favor selecionar uma data antes")
            return
        }
        
        print("codData=\(codData)")
        
        if txtHoraInicio.text?.isEmpty ?? true{
            self.ME(userMessage: "Favor selecionar uma hora de início antes")
            return
        }
        if txtMinutoInicio.text?.isEmpty ?? true{
            self.ME(userMessage: "Favor selecionar um minuto de início antes")
            return
        }

        if txtHoraFim.text?.isEmpty ?? true{
            self.ME(userMessage: "Favor selecionar uma hora de término antes")
            return
        }
        if txtMinutoFim.text?.isEmpty ?? true{
            self.ME(userMessage: "Favor selecionar um minuto de término antes")
            return
        }

        var sHoraInicio:String = ""
        var sHoraFim:String = ""
        
        sHoraInicio = txtHoraInicio.text! + txtMinutoInicio.text!
        sHoraFim = txtHoraFim.text! + txtMinutoFim.text!
        print("HoraInicio=\(sHoraInicio)")
        print("HoraFim=\(sHoraFim)")
        
        var iS1:Int = 0
        var iS2:Int = 0
        
        iS1 = Int(sHoraInicio) ?? 0
        iS2 = Int(sHoraFim) ?? 0
        
        print("sHoraInicio=\(iS1)")
        print("sHotaFim=\(iS2)")
        
        if iS1 > iS2 {
            self.ME(userMessage: "A data de término precisa ser maior que a data de início")
            return
        }else{
            print ("menor")
            //ChamarConsultaDados()
            
            
            let ssplits = txtData.text?.split(separator: "/")
            //print(ssplits?.count ?? 0)
   
            if(ssplits?.count==3){
                sDtaInicio = String(ssplits?[2] ?? "") + "-"
                sDtaInicio += String(ssplits?[1] ?? "") + "-"
                sDtaInicio += String(ssplits?[0] ?? "")
                sDtaInicio += " " + txtHoraInicio.text! + ":" + txtMinutoInicio.text!
                sDtaInicio += ":00 "

                sDtaFim = String(ssplits?[2] ?? "") + "-"
                sDtaFim += String(ssplits?[1] ?? "") + "-"
                sDtaFim += String(ssplits?[0] ?? "")
                sDtaFim += " " + txtHoraFim.text!
                sDtaFim += ":" + txtMinutoFim.text! + ":00"
                
                //sDtaInicio = "\(String(describing: txtData.text)) \(String(describing: txtHoraInicio)):\(String(describing: txtMinutoInicio)) \(String(describing: txtHoraFim)):\(String(describing: txtMinutoFim))"
                
                /*
                sDtaInicio = txtData.text!
                sDtaInicio = sDtaInicio + " " + txtHoraInicio.text!
                sDtaInicio = sDtaInicio + ":" + txtMinutoInicio! + ":00"
     */
                //sDtaInicio = txtData.text + txtHoraInicio + ":" + txtMinutoInicio + ":00" + " " + txtHoraFim + ":" + txtMinutoFim
                print("sDtaInicio=", sDtaInicio)
                print("sDtaFim=", sDtaFim)
                ChamarConsultaDados()
            }
        }
 


    }
    
    func ME(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Mensagem:", message: userMessage, preferredStyle: .alert);
        
        let okACtion = UIAlertAction(title:"Fechar", style: .default, handler:nil)
        
        myAlert.addAction(okACtion)
        
        
        present(myAlert, animated: true)
        
    }
    
    private func HabilitarBotoes(){
        txtHoraInicio.isEnabled=false
        txtMinutoInicio.isEnabled=false
        txtHoraFim.isEnabled = false
        txtMinutoFim.isEnabled = false

    }
    private func DesabilitarBotoes(){
        txtHoraInicio.isEnabled=true
        txtMinutoInicio.isEnabled=true
        txtHoraFim.isEnabled = true
        txtMinutoFim.isEnabled = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inicio VisMapFiltroViewController")
        icodTel = UserDefaults.standard.integer(forKey: "codTel")
        UserDefaults.standard.set("", forKey: "VisMapFiltro")
        //dados.append("teste")
        //dados.append("teste2")
        
        DesabilitarBotoes()
        
        var count = 0...23
        for number in count {
            Hora.append(String(format: "%02d", number))
            //print(String(format: "%02d", number))
        }
        
        count = 0...59
        for number in count{
            Minuto.append(String(format: "%02d", number))
        }
        
        print("Datas.count=\(Datas.count)")
        ChamarBanco()
        
        
        
    }
    
    @IBOutlet weak var lblFiltro: UILabel!
    
    
    func ChamarBanco()
    {
        print("Inicio ChamarBanco,icodTel = ", icodTel)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelDataTel"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        //let parameterDictionary = ["codTel" : icodTel] as [String : Any]
        let parameterDictionary = ["codTel" : icodTel, "Filtro" : 1]
        
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
                        //print(articleArray)
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                
                                if key.contains("dta"){
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    //self.dados.append(value as! String)
                                    
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    let dsP = DateFormatter()
                                    dsP.dateFormat = "dd/MM/yyyy"
                                    if let date = formatter.date(from: value as! String){
                                        //print("xxxx=", dsP.string(from: date))
                                        self.Datas.append(dsP.string(from: date))
                                        
                                    }else{
                                        print("deu merda")
                                    }
                                    
                                    
                                    
                                    //self.arrayRast.append(value as! String)
                                }else if key.contains("cod_data"){
                                    self.Datascod.append(value as! Int)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayRast.append("VOLTAR")
                
                
                DispatchQueue.main.sync {
                    //self.tableView.reloadData()
                    print("vai chamar reload")
                    self.pickerView.reloadAllComponents()
                    print("apos reload")
                }
 
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
   
    
    func ChamarConsultaDados()
    {
        print("Inicio ChamarConsultaDados visMapFiltroViewController,icodTel = ", icodTel)
        ArrayCoordenadas.removeAll()
        ArrayHorarioCoordenadas.removeAll()
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelDataTel"

        print("DtaInicio = \(sDtaInicio)")
        print("DtaFim = \(sDtaFim)")
        //print("DtaFim = \(codAcessoRastreador)")
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        //let parameterDictionary = ["codTel" : icodTel, "Filtro" : 2, "DtaInicio": "'2019-01-23 00:00:00'", "DtaFim" : "'2019-01-23 23:59:59'"] as [String : Any]
        let parameterDictionary = ["codTel" : icodTel, "Filtro" : 3,  "DtaInicio": "\(sDtaInicio)", "DtaFim" : "\(sDtaFim)", "DscIP": "", "Device": "", "codAcessoRastreador": "null", "TipoAcesso": 3, "codTipoDispositivo": "null"] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P5.0 ChamarConsultaDados")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                //print(parsedData)
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    print("P00  --- \(value)")
                    //print("P00 \(value)")
                    
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties")
                        //print(articleArray)
                        
                        for dict in articleArray{
                            print(1)

                            for(key, value) in dict {
                                print(2)
                                if key.contains("QTD"){
                                    
                                    i=i+1
                                    print("\(i) \(key) = \(value)")
                                    //self.dados.append(value as! String)
                                    self.iQTD = value as! Int
                                    
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.sync {
                    //self.tableView.reloadData()
                    //print("vai chamar reload")
                    //self.pickerView.reloadAllComponents()
                    print("Fm de tudo ChamarConsultaDados visMapFiltroViewController filtro = 3, iQTD =", self.iQTD)
                    if(self.iQTD==0){
                        self.ME(userMessage: "Não foi encontrado nenhum registro com a pesquisa")
                    }else if (self.iQTD>300){
                        self.ME(userMessage: "A pesquisa retornou mais de 300 registros, favor limitar o horário com prazo menor")
                    }else{
                        UserDefaults.standard.set(self.sDtaInicio, forKey: "DtaInicio")
                        UserDefaults.standard.set(self.txtData.text, forKey: "DataPesquisada")
                        UserDefaults.standard.set(self.sDtaFim, forKey: "DtaFim")
                        self.tabBarController?.selectedIndex = 0
                    }
                    
                }
 
                
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
    
}


