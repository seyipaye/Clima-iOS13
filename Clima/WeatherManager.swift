//
//  WeatherManager.swift
//  Clima
//
//  Created by Seyi Ipaye on 01/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import  CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager)
    func didFailWithError(_ error: Error)
}

class WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7f1b06d681d68fb92cc59ce42550bae8&units=metric"
    var delegate: WeatherManagerDelegate?
    var weatherModel: WeatherModel?
    
    func fetchWeather (with cityName: String) {
        weatherModel = nil
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(with location: CLLocationCoordinate2D) {
        let urlLatLon = "\(weatherURL)&lat=\(location.latitude)&lon=\(location.longitude)"
        performRequest(with: urlLatLon)
    }
    
    func performRequest (with urlString: String) {
        
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            
            //2. Create a url session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, respose, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    //print (String(data: safeData, encoding: .utf8) as Any)
                    
                    if let weatherModel = self.parseJSON(safeData) {
                        
                        self.weatherModel = weatherModel
                        self.delegate?.didUpdateWeather(self)
                    }
                    
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        //var weatherData: WeatherData? = nil
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            
            let weatherId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            
            
            return WeatherModel(conditionId: weatherId, cityName: cityName, temperature: temperature)
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
