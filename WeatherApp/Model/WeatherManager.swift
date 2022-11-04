//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Chukwubuikem Chukwudi on 05/03/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, cityName: String)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=<API_KEY>&units=metric"
    
//    let weatherGeoURL = "https://api.openweathermap.org/geo/1.0/direct?appid=<API_KEY>"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String = "Nigeria") {
        let urlString = "\(weatherURL)&q=\(cityName)"
//        let urlGeoString = "\(weatherGeoURL)&q=\(cityName)"
        performRequest(with: urlString, cityName: cityName)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, cityName: String) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString, cityName: cityName)
    }
    
    func performRequest(with urlString: String, cityName: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData, cityName: cityName) {
                        self.delegate?.didUpdateWeather(self, weather: weather, cityName: cityName)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data, cityName: String) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = cityName
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}


