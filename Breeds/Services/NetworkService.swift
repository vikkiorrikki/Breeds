//
//  NetworkService.swift
//  Breeds
//
//  Created by Виктория Саклакова on 11.08.2020.
//  Copyright © 2020 Viktoriia Saklakova. All rights reserved.
//

import Foundation

class NetworkService {
    
//     let requestURL = "https://dog.ceo/api/"
//        var delegate: WeatherManagerDelegate?
//        
//        func fetchCity(city: String) {
//            let urlString = "\(weatherURL)&q=\(city)"
//            performRequest(with: urlString)
//        }
//        func fetchWeather(latitude: Double, longtitude: Double){
//            let urlString = "\(weatherURL)&lon=\(longtitude)&lat=\(latitude)"
//            performRequest(with: urlString)
//        }
//        
//        func performRequest(with urlString: String) {
//    //        1. Create URL string
//            if let url = URL(string: urlString){
//                //        2. Create URL session
//                let session = URLSession(configuration: .default)
//                //        3. Give URL session a task
//                let task = session.dataTask(with: url) { (data, response, error) in
//                    if error != nil {
//                        self.delegate?.didFailWithError(error: error!)
//                    }
//                    if let safeData = data{
//                        if let weather = self.parseJSON(safeData){
//                            self.delegate?.didUpdateWeather(self, weather: weather)
//                        }
//                    }
//                }
//                //        4. Start a task
//                task.resume()
//            }
//        }
//        func parseJSON(_ weatherData: Data) -> WeatherModel? {
//            let decoder = JSONDecoder()
//            do{
//                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//                let temp = decodedData.main.temp
//                let name = decodedData.name
//                let conditionID = decodedData.weather[0].id
//                
//                let weatherModel = WeatherModel(cityName: name, conditionID: conditionID, temp: temp)
//                return weatherModel
//            }catch{
//                delegate?.didFailWithError(error: error)
//                return nil
//            }
//        }
}
