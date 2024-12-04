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
    

    
    func ChamarBanco() {
        print("Inicio ChamarBanco, icodTel = ", icodTel)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/SelTelHistoricoComando"

        // Parâmetros adicionais
        let parameterDictionary: [String: Any] = [
            "codTelHistoricoComando": 0,
            "codTel": icodTel,
            "codHistoricoComando": 0,
            "codDevice": 0
        ]
        
        // Verifica se a URL é válida
        guard let serviceUrl = URL(string: jsonUrlString) else {
            print("URL inválida.")
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Serializa os parâmetros para o corpo da requisição
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            print("Erro ao criar o corpo da requisição.")
            return
        }
        request.httpBody = httpBody
        
        // Executa a tarefa de rede
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data else {
                print("Erro: dados da resposta são nulos.")
                return
            }
            
            do {
                // Tenta desserializar o JSON
                guard let parsedData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Erro ao converter os dados para o formato esperado.")
                    return
                }
                
                var contador: Int = 0
                
                for (_, value) in parsedData {
                    if let articleArray = value as? [[String: Any]] {
                        for dict in articleArray {
                            for (key, value) in dict {
                                if key.contains("dsc"), let stringValue = value as? String {
                                    contador += 1
                                    print("\(contador) \(key) = \(stringValue)")
                                    self.arrayHistoricoComandos.append(stringValue)
                                    print("Adicionado no array: ", stringValue)
                                } else if key.contains("DtaCriacao"), let dateString = value as? String {
                                    print("Valor recebido = \(dateString)")
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                    
                                    if let date = dateFormatter.date(from: dateString) {
                                        let dataNova = DateFormatter()
                                        dataNova.dateFormat = "dd/MM/yyyy HH:mm"
                                        let timeStamp = dataNova.string(from: date)
                                        print("Timestamp formatado = \(timeStamp)")
                                        self.arraySub.append(timeStamp)
                                    } else {
                                        print("Erro ao converter a data: \(dateString)")
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Atualiza a interface na main thread para evitar bugs e crashs
                DispatchQueue.main.async {
                    print("Finalizando e recarregando dados.")
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print("Erro ao serializar o JSON: \(jsonError)")
            }
        }.resume()
    }
}
