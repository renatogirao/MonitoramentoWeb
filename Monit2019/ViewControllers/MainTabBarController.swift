//
//  MainTabBarController.swift
//  Monit2019
//
//  Created by Marcio Santos on 14/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit


class MainTabBarController: UITabBarController {
    
    var icodTel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("", forKey: "VisMapFiltro")
        print("Setor VisMapFiltro ='' MainTabBarController")
    }
    

}
