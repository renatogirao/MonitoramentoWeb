//
//  EnviarComandos.swift
//  Monit2019
//
//  Created by Marcio Santos on 07/02/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

struct retJsonStruct: Decodable{
    let Erro: String
    let Identity: Int
}

class EnviarComandos: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var TBView: UITableView!
    
    //var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let alert = UIAlertController(title: nil, message: "Pesquisando...", preferredStyle: .alert)
    
    
    
    var icodTel = 0
    var icodDevice: Int = 0
    var arrayEnviarComandos = [] as [String]
    var arrayicodComandoRastreadorModeloGpsxtel = [] as [Int]
    var arrayDtaSolic = [] as [String]
    var arrayDtaExecCanc = [] as [String]
    var arrayStatus = [] as [String]
    var arrayDevice = [] as [String]
    //var sHorarioTemp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inicio EnviarComandos")
        
        icodDevice = UserDefaults.standard.integer(forKey: "codDevice")
        print("icodDevice=", icodDevice)
        /*
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped=true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
 */

        ChamarComandos(MsgUsuarioFinalProcessamento: "")
        //showOverlay()
        
        
        /*somente esse bloco ja aparece a imagem Pesquisando...
        present(self.alert, animated: true, completion: nil)
        alert.dismiss(animated: true, completion: nil)
 */
        
        
        
        print(1)
        //alert.dismiss(animated: false, completion: nil)
        print(2)

    }
    
    public func showOverlay(){
        //let alert = UIAlertController(title: nil, message: "Pesquisando...", preferredStyle: .alert)
        
        /*
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y:5, width: 50, height:50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        
        loadingIndicator.startAnimating()
 */
        present(self.alert, animated: true, completion: nil)
        //self.presentedViewController(alert, animated: true, completion: nil)
        print("fim ShowOverlay")
        //self.alert.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
        //[alert .dismiss(animated: true, completion: nil)]
        
        //self.dismissModalViewController(animated: false)
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEnviarComandos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("passou cellForRowAt, indexPath = ", indexPath.row)
        let cellIdentifier = "CellEnviarComando"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if(arrayStatus[indexPath.row] == "A"){
            cell.textLabel?.text = arrayEnviarComandos[indexPath.row] + " (pendente)"
        }else if(arrayStatus[indexPath.row] == "C"){
            cell.textLabel?.text = arrayEnviarComandos[indexPath.row] + " (cancelado)"
        }else if(arrayStatus[indexPath.row] == "F"){
            cell.textLabel?.text = arrayEnviarComandos[indexPath.row] + " (executado)"
        }else{
            cell.textLabel?.text = arrayEnviarComandos[indexPath.row]
        }
        
        if(arrayDtaSolic[indexPath.row] == ""){
            cell.detailTextLabel?.textColor = UIColor.black
        }else{
            if(arrayStatus[indexPath.row] == "C"){
                cell.detailTextLabel?.textColor = UIColor.orange
            }else if(arrayStatus[indexPath.row] == "F"){
                cell.detailTextLabel?.textColor = UIColor.blue
            }else{
                cell.detailTextLabel?.textColor = UIColor.red
            }
        }
        if(arrayDtaSolic[indexPath.row] == ""){
            cell.detailTextLabel?.text = arrayDtaSolic[indexPath.row]
        }else{
            if(arrayStatus[indexPath.row] == "C" || arrayStatus[indexPath.row] == "F"){
                cell.detailTextLabel?.text = arrayDtaExecCanc[indexPath.row] + " - " +
                    arrayDevice[indexPath.row]
            }else{
                cell.detailTextLabel?.text = arrayDtaSolic[indexPath.row] + " - " +
                arrayDevice[indexPath.row]
            }
        }
        
        //arrayDevice[indexPath.row].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sT: String
        sT = arrayEnviarComandos[indexPath.row]
        print("st=", sT," status = ", arrayStatus[indexPath.row])
        if(arrayStatus[indexPath.row] == "A"){
            print("status aguardando")
            CreateAlert(Titulo: "Deseja cancelar esse comando?", MSG: "", index: indexPath.row)
        }else if(arrayStatus[indexPath.row] == "" || arrayStatus[indexPath.row] == "C" ){
            print("vazio ou C")
            CreateAlert(Titulo: "Deseja enviar o comando:", MSG: arrayEnviarComandos[indexPath.row] + "?", index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func ChamarComandos(MsgUsuarioFinalProcessamento: String)
    {
        if(MsgUsuarioFinalProcessamento != ""){
            print("limpando arrays")
            arrayEnviarComandos.removeAll()
            arrayicodComandoRastreadorModeloGpsxtel.removeAll()
            arrayDevice.removeAll()
            arrayStatus.removeAll()
            arrayDtaSolic.removeAll()
            arrayDtaExecCanc.removeAll()
            DispatchQueue.main.sync {
            
                self.TBView.reloadData()
            }
            //return
        }
        
        
        print("Inicio ChamarComandos, icodTel = ", icodTel)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelComandoRastreadorModeloGpsxtel/Pesquisar"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["Filtro" : 1, "codComandoRastreadorModeloGpsxtel" : "null", "codTel" : icodTel, "Status": "null", "codDevice": "null"] as [String : Any]
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
                                if (key == "comando_rastreador"){
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    self.arrayEnviarComandos.append(value as! String)
                                    //print("adicionou no array ", value)
                                    
                                }else if (key == "DtaSolic"){
                                    if((value as? NSNull) == nil){
                                        print("DtaSolic.\(i) \(key) = \(value)")
                                        
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
                                        
                                        //self.arraySub.append(timeStamp)
                                        
                                        //self.arrayDtaSolic.append(value as! String)
                                        self.arrayDtaSolic.append(timeStamp)
                                    }else{
                                        print("nulo")
                                        self.arrayDtaSolic.append("")
                                    }
                                }else if (key == "DtaExecCanc"){
                                    if((value as? NSNull) == nil){
                                        print("DtaExecCanc.\(i) \(key) = \(value)")
                                        
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
                                        
                                        self.arrayDtaExecCanc.append(timeStamp)
                                    }else{
                                        self.arrayDtaExecCanc.append("")
                                    }
                                }else if (key == "Status"){
                                    if((value as? NSNull) == nil){
                                        self.arrayStatus.append(value as! String)
                                    }else{
                                        self.arrayStatus.append("")
                                    }
                                    //}else if key.contains("device"){
                                }else if (key == "device"){
                                    //print("\(i) \(key) = \(value)")
                                    //print("objeto=", self.getClassName(obj: value as AnyObject))
                                    if((value as? NSNull) == nil){
                                        //self.arrayDevice.append(value as! NSNumber)
                                        //self.arrayDevice.append(String(stringInterpolation: value as! String))
                                        self.arrayDevice.append(value as? String ?? "")
                                    }else{
                                        self.arrayDevice.append("")
                                    }
                                }else if(key == "cod_ComandoRastreadorModeloGps_tel"){
                                    //print("\(i) \(key) = \(value)")
                                    self.arrayicodComandoRastreadorModeloGpsxtel.append(value as! Int)
                                }

                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayHistoricoComandos.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    print("final reloadData")
                    self.alert.dismiss(animated: true, completion: nil)
                    print("precisa ter escondido")
                    self.TBView.reloadData()
                    
                    if(MsgUsuarioFinalProcessamento != ""){
                        print("MsgUsuarioFinalProcessamento=", MsgUsuarioFinalProcessamento)
                        
                        self.showFechar(title: MsgUsuarioFinalProcessamento, message: "", handlerOK: {action in
                            print("clicou no botao Comando enviado")
                        })

                        
                    }else{
                        print("MsgUsuarioFinalProcessamento = ''")
                    }
                }
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
    
    
    func getClassName(obj : AnyObject) -> String
    {
        let objectClass : AnyClass! = object_getClass(obj)
        let classname = objectClass.description()
        
        return classname
    }
    
    func CreateAlert (Titulo:String, MSG:String, index: Int)
    {
        print("CreatAlert, index=", index)
        
        showAlert(title: Titulo, message: MSG, handlerOK: {action in
            print("Sim, MSG = ", MSG)
            //self.AtivarAmpulheta()
            if(MSG == "Parar veiculo?"){
                self.EnviarComando(index: index)
            }else if(MSG == "Liberar veiculo?"){
                print("liberar veiculo")
                self.EnviarComando(index: index)
            }else if(MSG==""){
                print("Pedir para cancelar comando")
                //self.CancelarComando(index: index)
                self.EnviarComando(index: index)
            }else if(MSG=="Move?" || MSG=="Aviso Veiculo Ligou?" || MSG=="Aviso Veiculo Desligou?" || MSG=="Aviso Porta Abriu?" || MSG=="Aviso Alarme Ignicao?"){
                print("Pedir MSG = ", MSG)
                //self.CancelarComando(index: index)
                self.EnviarComando(index: index)
            }
        }, handlerCancel: {actionCancel in
            print("Nao")
        })
        
    }
    
    func CancelarComando(index: Int){
        print("chegou index em CancelarComando=", index)
        var icodComandoRastreadorModeloGpsxtel : Int
        icodComandoRastreadorModeloGpsxtel = arrayicodComandoRastreadorModeloGpsxtel[index]
        print("icodComandoRastreadorModeloGpsxtel=", icodComandoRastreadorModeloGpsxtel)
        print("Status=", arrayStatus[index])
        
        ChamarAtualizar(index: index, Status: "C", icodDevice: icodDevice)
    }

    func EnviarComando(index: Int){
        print("chegou index em EnviarComando, index=", index)
        var icodComandoRastreadorModeloGpsxtel : Int
        icodComandoRastreadorModeloGpsxtel = arrayicodComandoRastreadorModeloGpsxtel[index]
        print("icodComandoRastreadorModeloGpsxtel=", icodComandoRastreadorModeloGpsxtel)
        print("Status=", arrayStatus[index])
        
        //Status = C = esta cancelado no momento que clicou na opcao, entao automaticamente ele quer processar o comando
        //F = finalizado
        //'' = sem nunca ter pedido esse comando
        if(arrayStatus[index]=="C" || arrayStatus[index]=="F" || arrayStatus[index]==""){
            print("V1 decider como chamar, status = ", arrayStatus[index])
            ChamarAtualizarTESTE(index: index, Status: "A", icodDevice: icodDevice)
        }
        //Statys = A = esta com o comando já solicitado e esta aguardando processar (P-pendente), entao enviar C = cancelar
        if(arrayStatus[index]=="A"){
            print("V2 decider como chamar, status = ", arrayStatus[index])
            ChamarAtualizarTESTE(index: index, Status: "C", icodDevice: icodDevice)
        }

    }

    
    /*
    func AtivarAmpulheta(){
        print("Inicio AtivarAmpulheta")
        activityIndicator.startAnimating()
    }
    
    func CancelarAmpulheta(){
        print("Inicio CancelarAmpulheta")
        activityIndicator.stopAnimating()
    }
 */
    
    
    func ChamarAtualizarTESTE(index: Int, Status: String, icodDevice: Int){
        print("Inicio ChamarAtualizarTESTE, icodTel = ", icodTel, " index=", index, " Status que vai setar = " , Status, " icodDevice = ", icodDevice, "arrayicodComandoRastreadorModeloGpsxtel[index]=", arrayicodComandoRastreadorModeloGpsxtel[index], " dscComando = ", arrayEnviarComandos[index])
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelComandoRastreadorModeloGpsxtel/ComandoRastreadorModeloGps_tel_x_IP_x_DeviceIncluir"
        
        
        /*
        if(arrayEnviarComandos[index]==""){
            print( "erro vazio, index = ", index)
            return
        }else{
            print("aaaa")
            return
        }*/

        let parameterDictionary = ["codComandoRastreadorModeloGpsxtel" : arrayicodComandoRastreadorModeloGpsxtel[index], "codDevice" : icodDevice, "Status": Status, "dscComando": arrayEnviarComandos[index]] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        
        print("vai chamar URLSession")
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0 ChamarAtualizarTESTE")
            let dataAsString = String(data: data, encoding: .utf8)
            print("dataString=", dataAsString ?? "")
            //print(data)
            
                do {
                    
                    print("inicio retJson")
                    let retJson = try JSONDecoder().decode([retJsonStruct].self, from: data)
                    //print(myStruct)
                    //myStruct.forEach{ print($0)}
                    print("Erro=",retJson[0].Erro)
                    print("Identity=", retJson[0].Identity)
                    if(retJson[0].Erro == "0"){
                        
                        print("Chamar ChamarComandos com msg=Comando enviado")
                        self.ChamarComandos(MsgUsuarioFinalProcessamento: "Comando enviado")
                        

                    }else{
                        self.showFechar(title: "Comando NÃO enviado", message: "tente novamente em alguns segundos", handlerOK: {action in
                            print("Clicou em Fechar")
                        })

                    }
                    

                }catch let jsonErr{
                    print("Error serializing json:", jsonErr)
                }
            
            }.resume()
        
        
        
        
        

 
    }
    
    func ChamarAtualizar(index: Int, Status: String, icodDevice: Int)
    {
        print("Inicio ChamarAtualizar, icodTel = ", icodTel, " index=", index, " Status = " , Status, " icodDevice = ", icodDevice, "arrayicodComandoRastreadorModeloGpsxtel[index]=", arrayicodComandoRastreadorModeloGpsxtel[index])
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelComandoRastreadorModeloGpsxtel/ComandoRastreadorModeloGps_tel_x_IP_x_DeviceIncluir"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["codComandoRastreadorModeloGpsxtel" : arrayicodComandoRastreadorModeloGpsxtel[index], "codDevice" : icodDevice, "Status": Status] as [String : Any]
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
            //print(data)
            
            do {
               

                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    //print("P00  \(key) --- \(value)")
                    print("P00  \(value)")
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        //print("is array of dicionaties")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                //print("\(i) \(key) = \(value)")
                                if (key == "comando_rastreador"){
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    self.arrayEnviarComandos.append(value as! String)
                                    //print("adicionou no array ", value)
                                    
                                
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayHistoricoComandos.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    print("final reloadData chamarAtualizar")
                    //self.alert.dismiss(animated: true, completion: nil)
                    //print("precisa ter escondido")
                    //self.TBView.reloadData()
                    
                    if(Status == "C"){
                        self.arrayStatus[index] = "C"
                        print("Status=", self.arrayStatus[index])
                        self.TBView.reloadData()
                    }else if(Status == "A"){
                        self.arrayStatus[index] = "A"
                        print("Status=", self.arrayStatus[index])
                        self.TBView.reloadData()
                    }
                }

                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
 
 
        }
 
            
    
}
