//
//  WeatherManager.swift
//  Clima
//
//  Created by Seyi Ipaye on 01/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import  CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
        
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let lastLocation = locations.last?.coordinate {
                weatherManager.fetchWeather(with: lastLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func currendLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city name"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            
            weatherManager.fetchWeather(with: city)
        }
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager) {
        if let weatherModel = weatherManager.weatherModel {
            
            DispatchQueue.main.async {

                self.temperatureLabel.text = weatherModel.temperarureString
                self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
                self.cityLabel.text = weatherModel.cityName
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
