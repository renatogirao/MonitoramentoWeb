//
//  LocationManager.swift
//  Monit2019
//
//  Created by Renato Savoia Girão on 05/12/24.
//  Copyright © 2024 MonitoramentoWeb. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager() // Singleton
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Melhor precisão
    }
    
    // Solicitar permissão do usuário
    func requestLocationAuthorization() {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Solicita permissão "durante o uso do app"
        case .restricted, .denied:
            print("Localização não autorizada. Solicitar permissão nas configurações.")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Permissão já concedida. Iniciando atualizações de localização.")
            startUpdatingLocation()
        @unknown default:
            print("Status desconhecido.")
        }
    }
    
    // Iniciar atualizações de localização
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Parar atualizações de localização
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Delegate: Atualização de localização
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        currentLocation = latestLocation
        print("Localização atual: \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
    }
    
    // Delegate: Tratamento de erros
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
}

