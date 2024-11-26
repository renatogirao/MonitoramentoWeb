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
