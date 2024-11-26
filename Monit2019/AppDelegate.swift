//
//  AppDelegate.swift
//  Monit2019
//
//  Created by Marcio Santos on 30/12/2018.
//  Copyright © 2018 MonitoramentoWeb. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseCore
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        GMSServices.provideAPIKey("AIzaSyCqKKTm15Js1XfnxonZuXFIMyPv61H6eAg")
        GMSServices.provideAPIKey("AIzaSyCdfOMw9h34d8WYuoIZ2kTYZkmMd3pJgzI")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
//        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    //aqui executa quando chega mensagem, silenciosa ou nao
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        print("mensagem didReceiveRemoteNotification")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        //ler body
        let dict = userInfo["aps"] as! NSDictionary
        var messageBody:String?
        /*
         messageBody = dict["alert"] as? String
         print("Message body is  \(messageBody!)")
         */
        var parametro:String?
        var messageTitle:String = "Alert"
        if let alertDict = dict["alert"] as? Dictionary<String, String> {
            parametro = userInfo["Parametro1"] as? String
            messageBody = alertDict["body"]!
            if alertDict["title"] != nil {messageTitle = alertDict["title"]! }
        } else {
            messageBody = dict["alert"] as? String
        }
        
        
        
        print("message body = \(messageBody!)")
        print("message title \(messageTitle)")
        print("message parametro \(String(describing: parametro))")
        
        let result = parametro!.split(separator: "/")
        print("count=", result.count)
        if(result.count>0){
            print("result[0]=", result[0])
            print("result[1]=", result[1])
            print("result[2]=", result[2])
            if(result[0]=="(AvisoMove)" || result[0]=="(AvisoAccON)"){
                print("chegou aviso didReceiveRemoteNotification \(result[0])")
                ChamarComandos(icodDeviceEnviar: Int(result[2])!)
            }
            
            /*
            "){
            self.showAlertAppDelegate(title: "Aviso veículo ligou", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoAccOFF)"){
            self.showAlertAppDelegate(title: "Aviso veículo desligou", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoDoorAlarm)"){
            self.showAlertAppDelegate(title: "Aviso de porta", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoAccAlarm)"){
            self.showAlertAppDelegate(title: "Aviso de ACC acionado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoSOS)"){
            self.showAlertAppDelegate(title: "Aviso de SOS acionado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoLowBattery)"){
            self.showAlertAppDelegate(title: "Aviso de bateria baixa", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoVeiculoFoiDesbloqueado)"){
            self.showAlertAppDelegate(title: "Aviso de veículo desbloqueado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
        }else if(result![0]=="(AvisoVeiculoFoiBloqueado)"
            
            */
            
            
            
        }
        /*
         Bloco abaixo é quando a mensagem é no formato silenciosa
        var sBody: String
        sBody = userInfo["body"] as! String
        print("sBody=", sBody)
        let result = sBody.split(separator: "/")
        print("count=", result.count)
        print("result[0]=", result[0])
        print("result[1]=", result[1])
        print("result[2]=", result[2])
        if(result[0]=="(AvisoMove)"){
            print("chegou aviso de Move")
            ChamarComandos(icodDeviceEnviar: Int(result[2])!)
        }
        */
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    //aqui passa vai apresentar a mensagem, somente quando o app esta ativo foreground
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("inicio willpresent - nao licenciosa")
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let season = notification.request.content.userInfo["season"]
        {
            print("Season: \(season)")
        }
        
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        //ler body
        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        
        var messageBody:String?
        
        /*
        messageBody = dict["alert"] as? String
        print("Message body is  \(messageBody!)")
 */
        var parametro:String?
        var messageTitle:String = "Alert"
        
        if let alertDict = dict["alert"] as? Dictionary<String, String> {
            messageBody = alertDict["body"]!
            parametro = userInfo["Parametro1"] as? String
            if alertDict["title"] != nil {messageTitle = alertDict["title"]! }
        } else {
            messageBody = dict["alert"] as? String
        }
    
        print("message body willpresent = \(messageBody!)")
        print("message title willpresent = \(messageTitle)")
        print("message parametro willpresent \(String(describing: parametro))")
        
        if(parametro!.contains("/")){
            print("tem barra no parametro")
            let result = parametro?.split(separator: "/")
            print("result.count=", result?.count as Any)
            print("result0=", result![0])
            if(result![0]=="(AvisoMove)"){
                self.showAlertAppDelegate(title: "Aviso de movimento", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoAccON)"){
                self.showAlertAppDelegate(title: "Aviso veículo ligou", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoAccOFF)"){
                self.showAlertAppDelegate(title: "Aviso veículo desligou", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoDoorAlarm)"){
                self.showAlertAppDelegate(title: "Aviso de porta", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoAccAlarm)"){
                self.showAlertAppDelegate(title: "Aviso de ACC acionado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoSOS)"){
                self.showAlertAppDelegate(title: "Aviso de SOS acionado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoLowBattery)"){
                self.showAlertAppDelegate(title: "Aviso de bateria baixa", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoVeiculoFoiDesbloqueado)"){
                self.showAlertAppDelegate(title: "Aviso de veículo desbloqueado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }else if(result![0]=="(AvisoVeiculoFoiBloqueado)"){
                self.showAlertAppDelegate(title: "Aviso de veículo bloqueado", message: String(result![1]), buttonTitle: "Ok", window: self.window!)
            }
        }else{
            self.showAlertAppDelegate(title: messageTitle, message: messageBody!, buttonTitle: "Ok", window: self.window!)

        }
        
        // Change this to your preferred presentation option
        //completionHandler([])
        
    }
    

    
    func showAlertAppDelegate(title: String, message: String, buttonTitle: String, window: UIWindow){
        print("Inicio showAlertAppDelegate, title = \(title) message = \(message)")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler:nil))
        
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        updateBadgeCount()
        completionHandler()
    }
}

func updateBadgeCount()
{
    var badgeCount = UIApplication.shared.applicationIconBadgeNumber
    if badgeCount > 0
    {
        badgeCount = badgeCount-1
    }
    UIApplication.shared.applicationIconBadgeNumber = badgeCount
}
/*
			extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(Firebase registration token: \(fcmToken)")
        
  */
              
              
              
              /*
        UserDefaults.standard.set(fcmToken, forKey: "DeviceTokenString")
 */
        

/*
        InstanceID.instanceID().instanceID{(result, error) in
            if let error = error {
                print("Error fetching remote: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
                UserDefaults.standard.set(result.token, forKey: "DeviceTokenString")
            }
        }
  */
        //UserDefaults.standard.set("A", forKey: "DeviceTokenStringJaRegistrado")
        //let dataDict:[String: String] = ["token": fcmToken]
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    //}
    

/*
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Messaage data:", remoteMessage.appData)
    }
 */
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //var deviceTokenString = ""
        /*
        deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("didRegisterForRemoteNotificationsWithDeviceToken deviceTokenString=", deviceTokenString)
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceTokenString")
        print("deviceTokenString salvo (didRegisterForRemoteNotificationsWithDeviceToken)")
 */
        
        /*
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeedde! token =", token)
 */
   
        
        /*
        InstanceID.instanceID().instanceID{(result, error) in
        if let error = error {
            print("Error fetching remote: \(error)")
        }else if let result = result {
            print("Remote instance ID token: \(result.token)")
            UserDefaults.standard.set(result.token, forKey: "DeviceTokenString")
         }
        }
         */
        
        
        
        
        //se for usar o servidor da apple precisa pegar esse token
        /*
        if let newToken = InstanceID.instanceID().token(){
            print("New token \(newToken)")
        }
        */
        
    }
    
    func ChamarComandos(icodDeviceEnviar: Int)
    {
        
        print("Inicio ChamarComandos, icodDeviceEnviar = ", icodDeviceEnviar)
        let jsonUrlString = "http://177.144.136.91:8095/monitoramentoweb/api/Device/AtualizaDtaRecebidoDispositivo"
        
        //guard let url = URL(string: jsonUrlString) else {return}
        
        //adicional
        let parameterDictionary = ["Filtro" : 1, "codDeviceEnviar" : icodDeviceEnviar, "codDevice" : 0, "Msg": "", "Status": "", "MsgErroRetornada": ""] as [String : Any]
        guard let serviceUrl = URL(string: jsonUrlString) else {return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:[]) else {return}
        request.httpBody = httpBody
        //------------
        print("vai chamar URLSession ChamarComandos, icodDeviceEnviar \(icodDeviceEnviar)")
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {return}
            print("P4.0 chamarComandso icodDeviceEnviar \(icodDeviceEnviar)")
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
                                if (key == "Erro"){
                                    i=i+1
                                    print("\(i) \(key) = \(value)")
                                    //self.arrayEnviarComandos.append(value as! String)
                                    //print("adicionou no array ", value)
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                //self.arrayHistoricoComandos.append("VOLTAR")
                
                DispatchQueue.main.sync {
                    print("final reloadData")
                }
                
                
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
    }

    
    
//}
