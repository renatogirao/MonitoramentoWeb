//
//  SelOpcViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 10/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

class SelOpcViewController:UIViewController{
    @IBAction func btVoltar(_ sender: Any) {
        print("clicou em Voltar")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var lblRast: UILabel!
    
    var sRastreador = ""
    var icodTel = 0
    var iErro = 0
    var icodAcessoRastreador = 0
    var iQTDAcessoDisponivel = 0
    var icodPlano = 0
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    
    
    @IBAction func btHistoricoComandos(_ sender: Any) {
        print("clicou em btHistoricoComandos, icodTel = ", icodTel)
        
        /*
         guard let VisMapView = mainStoryboard.instantiateViewController(withIdentifier: "HistoricoComandos") as? HistoricoComandos else {return}
         
         //VisMapViewController.sRastreador = arrayRast[indexPath.row]
         VisMapView.icodTel = icodTel
         
         present(VisMapView, animated: true, completion: nil)
         */
        
        UserDefaults.standard.set(icodTel, forKey: "codTel")
        /*
         if let tabbar = (storyboard?.instantiateViewController(withIdentifier: "HistoricoComandos") ){
         self.present(tabbar, animated: true, completion: nil)
         }
         */
        
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "HistoricoComandos") as? HistoricoComandos else{
            print("deu merda")
            return
        }
        
        destination.icodTel = icodTel
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func btEnviarComandos(_ sender: Any) {
        print("clicou em EnviarComandos, icodTel = ", icodTel)
        
        UserDefaults.standard.set(icodTel, forKey: "codTel")
        
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "EnviarComandos") as? EnviarComandos else{
            print("deu merda")
            return
        }
        
        destination.icodTel = icodTel
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func btVisualizar(_ sender: Any) {
        print("clicou em visualizar selOpcViewController")
        
        print("pesquisar qtd disponivel para gps, icodTel = ", icodTel)
        print("pesquisar qtd disponivel para gps, icodPlano = ", icodPlano)
        
        if((icodPlano == 4) || (icodPlano == 5) || (icodPlano == 6))
        {
            print("Entrou icodPlano = ", icodPlano)
            ChamarVisualizaUltPos()
        }else{
            print("vai chamar ChamarAcessoRastreador, Entrou icodPlano = ", icodPlano)
            ChamarAcessoRastreador()
        }
        
        
    }
    
    func ChamarTab()
    {
        /*
         let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         
         guard let VisMapView = mainStoryboard.instantiateViewController(withIdentifier: "VisMapViewController") as? VisMapViewController else {return}
         
         //VisMapViewController.sRastreador = arrayRast[indexPath.row]
         VisMapView.icodTel = icodTel
         
         present(VisMapView, animated: true, completion: nil)
         */
        
        UserDefaults.standard.set(icodAcessoRastreador, forKey: "codAcessoRastreador")
        
        UserDefaults.standard.set(icodTel, forKey: "codTel")
        if let tabbar = (storyboard?.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController ){
            self.present(tabbar, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        lblRast.text = sRastreador
        print("Load SelOpcViewController icodTel=", icodTel)
        
    }
    
    func configureNavigationItem() {
        DispatchQueue.main.async {
            let backItem = UIBarButtonItem()
            backItem.title = "Voltar"
            self.navigationItem.backBarButtonItem = backItem
        }
    }
    
    func ChamarVisualizaUltPos()
    {
        print("Inicio ChamarVisualizaUltimaPos icodTel = ", icodTel)
        
        UserDefaults.standard.set(icodTel, forKey: "codTel")
        
        guard let Dest = mainStoryboard.instantiateViewController(withIdentifier: "VisualizaUltPosViewController") as? VisualizaUltPosViewController else{
            print("Couldnt find the view controller")
            return
        }
        
        Dest.sRastreador = sRastreador
        
        self.navigationController?.pushViewController(Dest, animated: true)
    }
    
    func ChamarAcessoRastreador()
    {
        print("Inicio ChamarAcessoRastreador icodTel = ", icodTel)
        
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/AcessoRastreador/AcessoRastreadorConsultar_SEM_codData"
        
        //adicional
        let parameterDictionary = ["codTel" : icodTel, "tipo" : 1] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P5.1 ChamarAcessoRastreador")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                //print(parsedData)
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    //print("P00  \(key) --- \(value)")
                    //print("P00 \(value)")
                    
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties 5.1 ChamarAcessoRastreador")
                        //print(articleArray)
                        
                        for dict in articleArray{
                            for(key, value) in dict {
                                print("P00.1  key=\(key) value=\(value)")
                                //print(2)
                                if key=="Erro"{
                                    
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    //self.dados.append(value as! String)
                                    
                                    self.iErro = Int((value as! NSString).doubleValue)
                                    
                                    //self.arrayRast.append(value as! String)
                                }else if key=="QTDAcessoDisponivel"{
                                    self.iQTDAcessoDisponivel = value as! Int
                                }else if key=="Identity"{
                                    self.icodAcessoRastreador = value as! Int
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayRast.append("VOLTAR")
                
                
                DispatchQueue.main.async {
                    //self.tableView.reloadData()
                    //print("vai chamar reload")
                    //self.pickerView.reloadAllComponents()
                    print("Fim de tudo ChamarAcessoRastreador. iErro = \(self.iErro)")
                    if(self.iErro == 45){
                        self.showFechar(title: "Houve um erro(45)", message: "Favor contatar suporte", handlerOK: {action in
                            print("Clicou em Fechar")
                        })
                    }else{
                        print("icodAcessoRastreador=\(self.icodAcessoRastreador)")
                        print("iQTDAcessoDisponivel=\(self.iQTDAcessoDisponivel)")
                        if(self.iQTDAcessoDisponivel < 0){
                            self.showFechar(title: "Atingido limite diário de acesso", message: "Aguarde o próximo período (00:00) ou adicione mais acessos.", handlerOK: {action in
                                print("Clicou em Fechar")
                            })
                            
                        }else{
                            self.ChamarTab()
                        }
                    }
                }
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
    }
    
    
}
