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
        configureTabBar()
        UserDefaults.standard.set("", forKey: "VisMapFiltro")
        print("Setor VisMapFiltro ='' MainTabBarController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTabBar()
    }
    
    func configureTabBar() {
        // Configurações gerais do UITabBar
        tabBar.tintColor = UIColor(rgb: 0x0E6BB9) // Cor do texto e ícone da aba selecionada
        tabBar.unselectedItemTintColor = UIColor(rgb: 0x4A4A4A) // Cor do texto e ícone das abas não selecionadas
        tabBar.backgroundColor = UIColor(rgb: 0xF5F5F5)
    }
}
