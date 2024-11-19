//
//  VisMapBtVoltarViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 14/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class VisMapBtVoltarViewController: UIViewController{
    
    var sVisMapFiltro = ""
    var icodTel = 0
    var ArrayLat = [String]()
    var ArrayLong = [String]()
    var ArrayHorarioCoordenadas = [String]()
    var sDtaInicio = ""
    var sDtaFim = ""
    var sGps = ""
    var sDataPesquisada = ""
    var icodAcessoRastreador = 0
    var Device:Int = 0
    
    //let marker = GMSMarker()
    
    
    var marker = GMSMarker()
    var mapView: GMSMapView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inicio VisMapBtVoltarViewController")
        
        icodTel = UserDefaults.standard.integer(forKey: "codTel")
        icodAcessoRastreador = UserDefaults.standard.integer(forKey: "codAcessoRastreador")
        Device = UserDefaults.standard.integer(forKey: "Device")
        print("icodAcessoRastreador=\(icodAcessoRastreador) Device=\(Device)")
        
        /*
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        marker.position = CLLocationCoordinate2D(latitude: -33.81, longitude: 151.20)
        marker.title = "Sidney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        print("Inicializou map na australia")
        */

        //MostrarBrasil()
        ChamarUltCoordenada()
        
    }
    
    func MostrarBrasil(){
        let camera = GMSCameraPosition.camera(withLatitude: -13.14, longitude: -52.42, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        /*
         marker.position = CLLocationCoordinate2D(latitude: -13.14, longitude: -52.42)
         marker.title = "Brasil"
         marker.snippet = "Brasil"
         marker.map = mapView
         */
        print("Inicializou map no brasil")

    }
    
    func ChamarUltCoordenada()
    {
        print("Inicio ChamarUltCoordenada VisMapBtVoltarViewController,icodTel =\(icodTel) Device=\(Device)")
        sGps = UserDefaults.standard.string(forKey: "Gps") ?? ""
        print("sGps (ChamarUltCoordenada)=\(sGps)")
        ArrayLat.removeAll()
        ArrayLong.removeAll()
        ArrayHorarioCoordenadas.removeAll()
        
        print("ArrayLat=\(ArrayLat.count)")
        print("ArrayLong=\(ArrayLong.count)")
        print("ArrayHorarioCoordenadas=\(ArrayHorarioCoordenadas.count)")
        
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelDataTel"
        var sCoordValida = ""
        var sHorarioValido = ""
        var sLatTemp = ""
        var sLongTemp = ""
        var sHorarioTemp = ""
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["codTel" : icodTel, "Filtro" : 4, "DtaInicio": "", "DtaFim" : "", "DscIP": "", "Device": Device, "codAcessoRastreador": icodAcessoRastreador, "TipoAcesso": "3", "codTipoDispositivo": "0"] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P5.1 ChamarUltCoordenada VisMapBtVoltarViewController")
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
                        print("is array of dicionaties 5.1")
                        //print(articleArray)
                        
                        for dict in articleArray{
                            sCoordValida = ""
                            sHorarioValido = ""
                            for(key, value) in dict {
                                print("P00.1  key=\(key) value=\(value) sCoordValida=\(sCoordValida) sHorarioValido=\(sHorarioValido) ")
                                //print(2)
                                if key=="Data"{
                                    
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    //self.dados.append(value as! String)
                                    
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    let dsP = DateFormatter()
                                    //dsP.dateFormat = "dd-MM-yyyy"
                                    dsP.dateFormat = "HH:mm:ss"
                                    if let date = formatter.date(from: value as! String){
                                        print("Horario:", dsP.string(from: date))
                                        //self.Datas.append(dsP.string(from: date))
                                        sHorarioValido = "S"
                                        sHorarioTemp = dsP.string(from: date)
                                        
                                        print("iniciar pegar data 5.1")
                                        dsP.dateFormat = "dd/MM/yyyy"
                                        if let date = formatter.date(from: value as! String){
                                            print("data = ", dsP.string(from: date))
                                            self.sDataPesquisada = dsP.string(from: date)
                                            print("sDataPesquisada=\(self.sDataPesquisada)")
                                        }
                                        
                                    }else{
                                        print("deu merda 5.1, valor = ", value)
                                    }
                                    
                                    
                                    
                                    //self.arrayRast.append(value as! String)
                                }else if key=="lat"{
                                    //self.Datascod.append(value as! Int)
                                    //print("Lat:  \(value)")
                                    sLatTemp = value as! String
                                }else if key=="long"{
                                    //self.Datascod.append(value as! Int)
                                    //print("Long:  \(value)")
                                    sLongTemp = value as! String
                                    sCoordValida = "S"
                                }
                                
                                if (sHorarioValido=="S" && sCoordValida=="S"){
                                    print("adicionado sLatTemp = \(sLatTemp) sLongTemp=\(sLongTemp) sHorarioTemp=\(sHorarioTemp)")
                                    self.ArrayLat.append(sLatTemp)
                                    self.ArrayLong.append(sLongTemp)
                                    self.ArrayHorarioCoordenadas.append(sHorarioTemp)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayRast.append("VOLTAR")
                
                
                DispatchQueue.main.sync {
                    //self.tableView.reloadData()
                    //print("vai chamar reload")
                    //self.pickerView.reloadAllComponents()
                    print("Fim de tudo ChamarUltCoordenada")
                    print("ArrayLat.count=\(self.ArrayLat.count)")
                    print("ArrayHorarioCoordenadas.count=\(self.ArrayHorarioCoordenadas.count)")
                    
                    var sPosicionou = ""
                    
                    if(self.ArrayLat.count > 0){
                        print("uma ou mais coordenadas 5.1. Count = ",self.ArrayLat.count)
                        
                        let path = GMSMutablePath()
                        for i in 0..<self.ArrayLat.count {
                            //print(self.ArrayLat[i].count)
                            if (self.ArrayLat[i].count > 5 && self.ArrayLong[i].count > 5){
                                
                                if(sPosicionou == ""){
                                    sPosicionou = "S"
                                    //for i2 in stride(from: self.ArrayLat.count-1, to: 0, by: -1){
                                    //if (self.ArrayLat[i2].count > 5 && self.ArrayLong[i2].count > 5){
                                    print("5.1 posicionou em ", self.ArrayLat[i], self.ArrayLong[i])
                                    let camera = GMSCameraPosition.camera(withLatitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0, zoom: 16.0)
                                    self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                                    self.view = self.mapView
                                    //break
                                    //}
                                    //}
                                }
                                
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0)
                                
                                print("title=", self.sGps, " ", self.sDataPesquisada)
                                print("snippet=", self.ArrayHorarioCoordenadas[i])
                                
                                marker.title = "\(self.sGps) \(self.sDataPesquisada)"
                                marker.snippet = self.ArrayHorarioCoordenadas[i]
                                marker.map = self.mapView
                                if(i==0){
                                    marker.icon = UIImage(named: "flagcheP_2")
                                    //termino
                                    print("flag termino")
                                }else if(i==(self.ArrayLat.count-1)){
                                    marker.icon = UIImage(named: "flagVerdeLimpaP_2")
                                    //inicio
                                    print("flag Inicio")
                                }
                                path.add(CLLocationCoordinate2D(latitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0))
                                
                                //print("adicionou",self.ArrayLat[i], self.ArrayLong[i])
                                //}
                                
                                
                            }else{
                                print("deu merda 5.1, lat=\(self.ArrayLat[i]) long=\(self.ArrayLong[i])")
                            }
                            
                            
                        }
                        
                        
                        let polyline = GMSPolyline(path: path)
                        polyline.map = self.mapView
                        
                        
                        
                    }else{
                        self.ME(userMessage: "Não foi encontrado nenhum registro com o filtro selecionado")
                    }
                }
                
                
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }

    
    
    @IBAction func btVoltar(_ sender: Any) {
        print("Clicou voltar")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear VisMapBtVoltarViewController")
        
        sVisMapFiltro = UserDefaults.standard.string(forKey: "VisMapFiltro") ?? ""
        print("sVisMapFiltro=", sVisMapFiltro)
        if(sVisMapFiltro=="S"){
            print("removendo marker")
            sDtaInicio = UserDefaults.standard.string(forKey: "DtaInicio") ?? ""
            sDtaFim = UserDefaults.standard.string(forKey: "DtaFim") ?? ""
            sGps = UserDefaults.standard.string(forKey: "Gps") ?? ""
            sDataPesquisada = UserDefaults.standard.string(forKey: "DataPesquisada") ?? ""
            
            print("DtaInicio=\(sDtaInicio) DtaFim=\(sDtaFim) Gps=\(sGps) DataPesquisada=\(sDataPesquisada)")
            
            marker.map = nil
            
            /*
            let camera = GMSCameraPosition.camera(withLatitude: -23.469211, longitude: -46.661563, zoom: 16.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view = mapView
            */
            //var lat = -23.469211
            //var long = -46.661563
            
            ChamarConsultaDados()
            

            
        }
        
    }
    
    func ChamarConsultaDados()
    {
        print("Inicio ChamarConsultaDados VisMapBtVoltarViewController,icodTel =\(icodTel), DtaInicio=\(sDtaInicio) DtaFim=\(sDtaFim) Device=\(Device) icodAcessoRastreador=\(icodAcessoRastreador)")
        ArrayLat.removeAll()
        ArrayLong.removeAll()
        ArrayHorarioCoordenadas.removeAll()
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelDataTel"
        var sCoordValida = ""
        var sHorarioValido = ""
        var sLatTemp = ""
        var sLongTemp = ""
        var sHorarioTemp = ""
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["codTel" : icodTel, "Filtro" : 2, "DtaInicio": "\(sDtaInicio)", "DtaFim" : "\(sDtaFim)", "Device": Device, "codAcessoRastreador": icodAcessoRastreador, "TipoAcesso": 3, "codTipoDispositivo": "null"] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P5.0  ChamarConsultaDados VisMapBtVoltarViewController")
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString)
            
            do {
                
                
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                var i: Int = 0
                //print(parsedData)
                for(_, value) in parsedData{
                    //if key.contains("Nome"){
                    //print("P00  \(key) --- \(value)")
                    print("P00 \(value)")
                    
                    if let articleArray:[[String : Any]] = value as? [[String:Any]]{
                        print("is array of dicionaties")
                        //print(articleArray)
                        
                        for dict in articleArray{
                            //print(1)
                            sCoordValida = ""
                            sHorarioValido = ""
                            for(key, value) in dict {
                                //print(2)
                                if key.contains("Data"){
                                    
                                    i=i+1
                                    //print("\(i) \(key) = \(value)")
                                    //self.dados.append(value as! String)
                                    
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    
                                    let dsP = DateFormatter()
                                    //dsP.dateFormat = "dd-MM-yyyy"
                                    dsP.dateFormat = "HH:mm:ss"
                                    if let date = formatter.date(from: value as! String){
                                        print("Horario:", dsP.string(from: date))
                                        //self.Datas.append(dsP.string(from: date))
                                        sHorarioValido = "S"
                                        sHorarioTemp = dsP.string(from: date)
                                    }else{
                                        print("deu merda, valor = ", value)
                                    }
                                    
                                    
                                    
                                    //self.arrayRast.append(value as! String)
                                }else if key.contains("lat"){
                                    //self.Datascod.append(value as! Int)
                                    //print("Lat:  \(value)")
                                    sLatTemp = value as! String
                                }else if key.contains("long"){
                                    //self.Datascod.append(value as! Int)
                                    //print("Long:  \(value)")
                                    sLongTemp = value as! String
                                    sCoordValida = "S"
                                }
                                
                                if (sHorarioValido.contains("S") && sCoordValida.contains("S")){
                                    self.ArrayLat.append(sLatTemp)
                                    self.ArrayLong.append(sLongTemp)
                                    self.ArrayHorarioCoordenadas.append(sHorarioTemp)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayRast.append("VOLTAR")
                
                
                DispatchQueue.main.sync {
                    //self.tableView.reloadData()
                    //print("vai chamar reload")
                    //self.pickerView.reloadAllComponents()
                    print("Fm de tudo VisMapBtVoltar")
                    print(self.ArrayLat.count)
                    print(self.ArrayHorarioCoordenadas.count)
                    
                    var sPosicionou = ""
                    
                    if(self.ArrayLat.count > 0){
                        print("mais de uma coordenada.",self.ArrayLat.count)

                        let path = GMSMutablePath()
                        for i in 0..<self.ArrayLat.count {
                            //print(self.ArrayLat[i].count)
                            if (self.ArrayLat[i].count > 5 && self.ArrayLong[i].count > 5){
                                
                                if(sPosicionou == ""){
                                    sPosicionou = "S"
                                    //for i2 in stride(from: self.ArrayLat.count-1, to: 0, by: -1){
                                        //if (self.ArrayLat[i2].count > 5 && self.ArrayLong[i2].count > 5){
                                            print("posicionou em ", self.ArrayLat[i], self.ArrayLong[i])
                                            let camera = GMSCameraPosition.camera(withLatitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0, zoom: 16.0)
                                            self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                                            self.view = self.mapView
                                            //break
                                        //}
                                    //}
                                }
                                
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0)
                                marker.title = "\(self.sGps) \(self.sDataPesquisada)"
                                marker.snippet = self.ArrayHorarioCoordenadas[i]
                                    marker.map = self.mapView
                                if(i==0){
                                    marker.icon = UIImage(named: "flagcheP_2")
                                    //termino
                                    print("flag termino")
                                }else if(i==(self.ArrayLat.count-1)){
                                    marker.icon = UIImage(named: "flagVerdeLimpaP_2")
                                    //inicio
                                    print("flag Inicio")
                                }
                                path.add(CLLocationCoordinate2D(latitude: Double(self.ArrayLat[i]) ?? 0, longitude: Double(self.ArrayLong[i]) ?? 0))
                                        
                                //print("adicionou",self.ArrayLat[i], self.ArrayLong[i])
                                //}
 
                                
                            }else{
                                print("deu merda, lat=\(self.ArrayLat[i]) long=\(self.ArrayLong[i])")
                            }
                            
 
                        }
                        
                        
                        let polyline = GMSPolyline(path: path)
                        polyline.map = self.mapView
                        
                        
                        
                    }else{
                        self.ME(userMessage: "Não foi encontrado nenhum registro com o filtro selecionado")
                    }
                }
                
                
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }
    
    func ME(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Mensagem:", message: userMessage, preferredStyle: .alert);
        
        let okACtion = UIAlertAction(title:"Fechar", style: .default, handler:nil)
        
        myAlert.addAction(okACtion)
        
        
        present(myAlert, animated: true)
        
    }

}
