//
//  ViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 30/12/2018.
//  Copyright © 2018 MonitoramentoWeb. All rights reserved.
//

import UIKit

struct Login: Decodable{
    let ManterAmpulheta: String
    let RetMsgLogin:String
    
}

struct strLogin {
    let ManterAmpulheta: String
    let RetMsgLogin: String
    let codUsuarioGps: Int
    
    init(json: [String: Any]){
        ManterAmpulheta = json["ManterAmpulheta"] as? String ?? ""
        RetMsgLogin = json["RetMsgLogin"] as? String ?? ""
        codUsuarioGps = json["codUsuarioGps"] as? Int ?? 0
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSenha: UITextField!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    //var sSenha: UITextField;
    //var sEmail: UITextField;
    
    var sEmail:String = "";
    var sSenha:String = "";
    var sDeviceTokenString = "";
    var sDeviceTokenStringJaRegistrado = ""
    //var icodUsuarioGps:Int = 0;
    var Device:Int = 0
    var icodDevice:Int = 0
    var sProcessando = ""
    var sVersao = "208"


    @IBAction func btLogin(_ sender: UIButton) {
        print("clicou no botao Login, icodDevice=", icodDevice, " Device = " , Device)
        
        preProcessarBotaoLogin()
    }
    
    func preProcessarBotaoLogin(){
        print("Inicio preProcessarBotaoLogin sDeviceTokenStringJaRegistrado = ", sDeviceTokenStringJaRegistrado, " sDeviceTokenString= ", sDeviceTokenString)
        
        if(sDeviceTokenString==""){
            //buscar local novamente sDeviceTokenStringJaRegistrado, pois se foi primeira vez que executou app, pode ser que nao tenha dado tempo do servidor FCM ter processado ainda
            print("rebuscando sDeviceTokenString")
            sDeviceTokenString = UserDefaults.standard.string(forKey: "DeviceTokenString") ?? ""
            print("apos busca sDeviceTokenString = ", sDeviceTokenString)
            
        }
        
        if((sDeviceTokenStringJaRegistrado != "S" && sDeviceTokenString != "") || (sDeviceTokenStringJaRegistrado == "A" && sDeviceTokenString != "")){
            print("registrar Token na base")
            RegistrarFCM()
            return
        }
        
        print("vai chamar ProcessarBotaoLogin dentro de preProcessarBotaoLogin")
        ProcessarBotaoLogin()
    }
    
    func ProcessarBotaoLogin(){
        print("Inicio ProcessarBotaoLogin, Device = ", Device)
        if(Device == 0){
            if (sProcessando == ""){
                sProcessando = "S"
                
                let currentDT = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .medium
                //print("hora = ", dateFormatter.string(from: currentDT))
                //currentDT.addTimeInterval(60)
                print("setando hora no btLogin = ", dateFormatter.string(from: currentDT))
                
                UserDefaults.standard.set(currentDT, forKey: "HoraInicioProcessamento")
                
                //precisa chamar rotina de criacao do device
                print("Chamando IncDevice sProcessando = ''")
                IncDevice()
                
                return
            }else{
                print("Else sProcessando = '\(sProcessando)'")
                if let date2 = UserDefaults.standard.object(forKey: "HoraInicioProcessamento") as? Date {
                    print("xx=", Date().timeIntervalSince(date2))
                    if(Date().timeIntervalSince(date2) < 60 ){
                        print("Favor voltar após 1 minuto")
                        return
                    }else{
                        print("mais de 60 segundos, continuar")
                        //sProcessando = ""
                        //setaria a hora novamente
                        let currentDT = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = .medium
                        //print("hora = ", dateFormatter.string(from: currentDT))
                        //currentDT.addTimeInterval(60)
                        print("setando hora no btLogin = ", dateFormatter.string(from: currentDT))
                        
                        UserDefaults.standard.set(currentDT, forKey: "HoraInicioProcessamento")
                        
                        //precisa chamar rotina de criacao do device
                        print("Chamando IncDevice mais de 60 segundos")
                        IncDevice()
                        return
                    }
                }
            }
            
        }
        //print("return fim, nao deve ser executado")
        //return
        
        if txtEmail.text == nil{
            print("nulo")
        }else{
            //print ("nao nulo", txtEmail.text)
            print("nao nulo", txtEmail.text ?? "")
        }
        
        UserDefaults.standard.set(txtEmail.text, forKey: "Email")
        UserDefaults.standard.set(txtSenha.text, forKey: "Senha")
        //print("salvou=", txtEmail.text)
        //print("salvou=", txtSenha.text)
        
        //UserDefaults.standard.set
        print("Salvou os dados")
        
        sEmail = txtEmail.text ?? ""
        sSenha = txtSenha.text ?? ""
        
        print(sEmail)
        print(sSenha)
        
        if(txtEmail.text!.isEmpty){
            print("Email vazio")
            ME(userMessage: "E-mail inválido");
            return;
        }
        if(txtSenha.text!.isEmpty){
            print("Senha vazia")
            ME(userMessage: "Senha inválida");
            return;
        }
        
        
        
        
        AtivarAmpulheta()
        
        //ChamarBanco4GET()
        
        ChamarBanco3 {jsonPayLoad, error in
            print("iniciou CompletionHandler")
            DispatchQueue.main.async{
                
                
                let rtLogin = strLogin(json: jsonPayLoad!)
                
                print("ManterAmpulheta=",rtLogin.ManterAmpulheta)
                print("RetMsgLogin=", rtLogin.RetMsgLogin)
                print("codUsuarioGps=", rtLogin.codUsuarioGps)
                
                if rtLogin.ManterAmpulheta.elementsEqual("S"){
                    print("manter ampulheta")
                }else if rtLogin.RetMsgLogin.elementsEqual(""){
                    print("nao manter ampulheta")
                    self.ME(userMessage: "E-mail/Senha inválido(a)");
                    self.CancelarAmpulheta()
                }else if rtLogin.RetMsgLogin.elementsEqual("OK"){
                    self.CancelarAmpulheta()
                    print("Chamar rastreador")
                    UserDefaults.standard.set(rtLogin.codUsuarioGps, forKey: "codUsuarioGps")
                    
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    
                    guard let selRastViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SelRastController") as? SelRastController else{
                        print("Couldnt find the view controller")
                        return
                    }
                    
                    
                    /*
                     guard let selRastViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SelRastController2") as? SelRastController2 else{
                     print("Couldnt find the view controller2")
                     return
                     }*/
                    
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = "Voltar"
                    self.navigationItem.backBarButtonItem = backItem
                    
                    self.navigationController?.pushViewController(selRastViewController, animated: true)
                    
                    //self.present(selRastViewController, animated: true, completion: nil)
                    //self.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
                    
                    //self.navigationController?.pushViewController(selRastViewController, animated: true)
                    
                    print("Apos chamar rastreador")
                    
                }else{
                    self.ME(userMessage: "E-mail/Senha inválido(a)");
                    self.CancelarAmpulheta()
                }
                
                print("Terminou")
                
                
            }
        }
        
        print("fim")
    }
    
    func RegistrarFCM(){
        print("Inicio RegistrarFCM, Device = ", Device, " DeviceTokenString=", sDeviceTokenString)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/Device/AtualizaDevice"
        
     
       
        let parameterDictionary = ["Tipo" : 1, "codDevice" : 0, "Device": Device, "codDeviceSistema": 0, "RegGCM": "", "codUsuarioGps": 0, "Versao": "", "Ativo": "", "codDevicePlataforma": 0, "FCMToken": sDeviceTokenString] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        
        print("vai chamar URLSession")
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0")
            let dataAsString = String(data: data, encoding: .utf8)
            print("dataString=", dataAsString ?? "")
            //print(data)
            
            do {
                
                print("inicio retJson")
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                //var i: Int = 0
                for(_, value) in parsedData{
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        //print("is array of dicionaties")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                //print("\(i) \(key) = \(value)")
                                if (key == "Erro"){
                                    print("xxx")
                                    print("\(key) = \(value)")
                                    var sErro = ""
                                    sErro = value as! String
                                    if(sErro=="0"){
                                        print("retorno ok atualização do token")
                                        self.sDeviceTokenStringJaRegistrado = "S"
                                        UserDefaults.standard.set(self.sDeviceTokenStringJaRegistrado, forKey: "DeviceTokenStringJaRegistrado")
                                        self.preProcessarBotaoLogin()
                                    }else{
                                        self.showFechar(title: "token não atualizado", message: "tente novamente em alguns segundos", handlerOK: {action in
                                            print("Clicou em Fechar")
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
        
        
        
        
        
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        sDeviceTokenString = UserDefaults.standard.string(forKey: "DeviceTokenString") ?? ""
        sDeviceTokenStringJaRegistrado = UserDefaults.standard.string(forKey: "DeviceTokenStringJaRegistrado") ?? ""
        sEmail = UserDefaults.standard.string(forKey: "Email") ?? ""
        sSenha = UserDefaults.standard.string(forKey: "Senha") ?? ""
        icodDevice = UserDefaults.standard.integer(forKey: "icodDevice")
        Device = UserDefaults.standard.integer(forKey: "Device")
        
        print(UserDefaults.standard.string(forKey: "codUsuarioGps") ?? 0)
        print("LOAD Device = ", Device, " icodDevice = ", icodDevice)
        print("DeviceTokenString=", sDeviceTokenString)
        print("sDeviceTokenStringJaRegistrado=", sDeviceTokenStringJaRegistrado)

        
        //txtEmail.text =  "123121"
        txtEmail.text = sEmail
        txtSenha.text = sSenha
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped=true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(activityIndicator)
        
        //AtivarAmpulheta()
        if(Device == 0){
            print("Device = 0, Load, iniciar tentativa de incluir")
            let currentDT = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            //print("hora = ", dateFormatter.string(from: currentDT))
            //currentDT.addTimeInterval(60)
            print("setando hora no btLogin = ", dateFormatter.string(from: currentDT))
            
            UserDefaults.standard.set(currentDT, forKey: "HoraInicioProcessamento")
            
            //precisa chamar rotina de criacao do device
            sProcessando = "S"
            print("Chamando IncDevice sProcessando = 'S'")
            IncDevice()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        print("Passou viewdidDisappear")
    }
 
    
    func ME(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Mensagem:", message: userMessage, preferredStyle: .alert);
        
        let okACtion = UIAlertAction(title:"Fechar", style: .default, handler:nil)
        
        myAlert.addAction(okACtion)
        
        
        present(myAlert, animated: true)
        
    }
    
    func AtivarAmpulheta(){
    
        activityIndicator.startAnimating()
    }

    func CancelarAmpulheta(){
        print("Inicio CancelarAmpulheta")
        activityIndicator.stopAnimating()
    }

    
    func ChamarBanco4GET(){
        print("Inicio ChamarBanco4GET")
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/Acesso"
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(json)
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        print("Fim ChamarBanco4GET")

    }
    
    func ChamarBanco3(completionHandler:@escaping ([String: Any]?, Error?)->Void) {
        print("Inicio ChamarBanco3, Device = ", Device)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/Acesso"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        print("email=", sEmail, " Senha = ", sSenha)
        //let parameterDictionary = ["Mobile" : "Apple", "Email" : "contato@monitoramentoweb.com.br", "Senha" : "3236"]
        let parameterDictionary = ["Mobile" : "Apple", "Email" : sEmail, "Senha" : sSenha, "Device" : Device] as [String : Any]
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
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                //print(json)
                
                completionHandler(json, nil)
                

                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
        
        print("Fim ChamarBanco3")
    }


    func ChamarBanco2(){
        print("Inicio ChamarBanco2")
        let jsonUrlString = "https://api.letsbuildthatapp.com/jsondecodable/course"
        
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(json)

            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        print("Fim ChamarBanco2")
    }
    func ChamarBanco(){
        print("Inicio ChamarBanco")
        //let url = "http://177.144.136.91:8095/monitoramentoweb/api/Acesso"
        
        
        let Url = "http://177.144.136.91:8095/monitoramentoweb/api/Acesso"
        
        
        //adicional
        let parameterDictionary = ["Mobile" : "Apple", "Email" : "contato@monitoramentoweb.com.br", "Senha" : "3236"]
        guard let serviceUrl = URL(string: Url) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------

        print("P1.0")
        URLSession.shared.dataTask(with: request) { (data, response,error) in
            guard let data = data else {return}
            print("P1.1")
            let dataAsString = String(data: data, encoding: .utf8)
            print(dataAsString)
            do {
                print("P1.2")
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(json)
                print("P1.3")
            }catch let jsonErr{
                print("P1.4 (\(jsonErr.localizedDescription)")
            }
            
            
        }.resume()
        

        print("Fim Chamar Banco")
    }
    

    func IncDevice()
    {
        print("Inicio IncDevice ")
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/IncDevice"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["codDeviceSistema" : 2, "codDevicePlataforma" : 2, "Versao" : sVersao] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0 incDevice")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    //print("P00  \(key) --- \(value)")
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties incDevice")
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                
                                if key.contains("Device"){
                                    i=i+1
                                    print("\(i) \(key) = \(value)")
                                    self.Device = (value as AnyObject).integerValue
                                    self.sProcessando = ""
                                    print("Device ficou \(self.Device) e sProcessando = ''")
                                    //print("Device ficou \(value) e sProcessando = ''")
                                    //self.arrayRast.append(value as! String)
                                    UserDefaults.standard.set(self.Device, forKey: "Device")
                                    
                                }else if(key == "Identity"){
                                    print("\(key) = \(value)")
                                    self.icodDevice = (value as AnyObject).integerValue
                                    self.sProcessando = ""
                                    print("icodDevice ficou \(self.icodDevice) e sProcessando = ''")
                                    UserDefaults.standard.set(self.icodDevice, forKey: "codDevice")

                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayRast.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    //self.tableView.reloadData()
                }
                
                
            }catch let jsonErr{
                print("IncDevice Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }

}

