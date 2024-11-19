//
//  Extension+UIViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 07/02/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    
    func showAlert(title: String, message: String, handlerOK:((UIAlertAction) -> Void)?, handlerCancel:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Sim", style: .cancel, handler: handlerOK)
        let actionCancel = UIAlertAction(title: "Não", style: .destructive, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showFechar(title: String, message: String, handlerOK:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Fechar", style: .cancel, handler: handlerOK)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }


}
