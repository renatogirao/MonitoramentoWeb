//
//  VisMapViewController.swift
//  Monit2019
//
//  Created by Marcio Santos on 11/01/2019.
//  Copyright © 2019 MonitoramentoWeb. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class VisMapViewController:UIViewController{
    
    var icodTel = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entrou em VisMapViewController,", icodTel)
        /*
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.81, longitude: 151.20)
        marker.title = "Sidfney"
        marker.snippet = "Australia"
        marker.map = mapView
 */
    }
    
    func RemoveMarkers(){
        print("Function RemoveMarkers")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WillApear")
    }
}
