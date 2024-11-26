//
//  strLogin.swift
//  Monit2019
//
//  Created by Renato Savoia Girão on 22/11/24.
//  Copyright © 2024 MonitoramentoWeb. All rights reserved.
//


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
