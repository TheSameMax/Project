import Foundation
import CoreLocation

class WeatherService: ObservableObject {
    private let apiKey = "da2ac41a7e6d9512ea22bb385514471f"
    
    // Function for getting the weather by the name of the city
    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(response?.description ?? "Unknown error")")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                let weatherData = WeatherData(from: weatherResponse)
                completion(weatherData)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    // Function for obtaining weather by geolocation
    func fetchWeather(for location: CLLocation, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }


let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(response?.description ?? "Unknown error")")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                let weatherData = WeatherData(from: weatherResponse)
                completion(weatherData)
            } catch {
                print("Error decoding weather data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
