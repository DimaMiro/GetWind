//
//  WeatherViewController.swift
//  GetWind
//
//  Created by Dima Miro on 26.06.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "21130cc260da520ac6319903ce5f294e"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlet
    @IBOutlet weak var locationStringLabel: UILabel!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maxTamperatureStringLabel: UILabel!
    @IBOutlet weak var minTemperatureStringLabel: UILabel!
    @IBOutlet weak var humidityStringLabel: UILabel!
    @IBOutlet weak var pressureStringLabel: UILabel!
    @IBOutlet weak var windStringLabel: UILabel!
    @IBOutlet weak var cloudsStringLabel: UILabel!
    
    @IBOutlet weak var changeLocationButton: UIButton! {
        didSet {
            changeLocationButton.layer.cornerRadius = 6
            changeLocationButton.layer.borderWidth = 1
            changeLocationButton.layer.borderColor = UIColor(red: 186.0/255.0, green: 185.0/255.0, blue: 187.0/255.0, alpha: 1.0).cgColor
        }
    }
    
    @IBOutlet weak var forecastButton: UIButton!{
        didSet {
            forecastButton.layer.cornerRadius = 6
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Set up Nav bar
        setupNavigationBar()

        //TODO: Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - Networking
    //Here is the getWeatherData method
    func getWeatherData (url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data.")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.locationStringLabel.text = "Connections issues"
            }
            
        }
        
    }
    
    //MARK: - JSON Parsing
    //Here is the updateWeatherData method
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(tempResult - 273.5)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.conditions = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.conditions)
            let maxTempResult = json["main"]["temp_max"].doubleValue
            weatherDataModel.maxTemperature = Int(maxTempResult - 273.5)
            let minTempResult = json["main"]["temp_min"].doubleValue
            weatherDataModel.minTemperature = Int(minTempResult - 273.5)
            weatherDataModel.pressure = json["main"]["pressure"].intValue
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.wind = json["wind"]["speed"].doubleValue
            weatherDataModel.clouds = json["clouds"]["all"].intValue
            
            updateUiWithWeatherData()
            
        } else {
            alert(title: "Issue", message: "Seems that something went wrong. Please try again.", style: .alert)
            locationStringLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Update
    //Here is the updateUiWithWeatherData method
    func updateUiWithWeatherData () {
        //Get and display current Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd"
        let currentDate = formatter.string(from: date)
        currentDateLabel.text = "\(currentDate)"
        //Display main values
        locationStringLabel.text = "In \(weatherDataModel.city) today you have"
        currentTemperatureLabel.text = "\(weatherDataModel.temperature)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        //Display additional values
        maxTamperatureStringLabel.text = "Max: \(weatherDataModel.maxTemperature)°С"
        minTemperatureStringLabel.text = "Min: \(weatherDataModel.minTemperature)°С"
        humidityStringLabel.text = "Humidity: \(weatherDataModel.humidity)%"
        pressureStringLabel.text = "Pressure: \(weatherDataModel.pressure) hPa"
        windStringLabel.text = "Wind: \(weatherDataModel.wind) meter/sec"
        cloudsStringLabel.text = "Clouds: \(weatherDataModel.clouds)%"
        
    }
    
    //MARK: - Location Manager Methods
    //Here is the didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(currentLocation.coordinate.longitude), latitude = \(currentLocation.coordinate.latitude)")
            
            let latitude = String(currentLocation.coordinate.latitude)
            let longitude = String(currentLocation.coordinate.longitude)
            
            let locationParameters : [String : String] = ["lat": latitude, "lon": longitude, "appid" : APP_ID]
            
            getWeatherData (url: WEATHER_URL, parameters: locationParameters)
        }
    }
    //Here is the didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationStringLabel.text = "Location is unavailable"
        
    }
    
    //MARK: - Change City Delegate Methods
    //Here is the userEnteredANewCityName method
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //MARK: - Here is the PrepereForSegue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Transition to ChangeCityViewController
        if segue.identifier == "changeCityName" {
            
            let destinationChangeCityVC = segue.destination as! ChangeCityViewController
            
            destinationChangeCityVC.delegate = self
            
        }
        //Transition to ForecastViewController
        if segue.identifier == "goToForecast" {
            
            let destinationForecastVC = segue.destination as! ForecastViewController
            destinationForecastVC.currentLocationFromWeatherVC = weatherDataModel.city
            
        }
    }
    // MARK: - Alert method
    func alert (title: String, message: String, style: UIAlertControllerStyle) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: style)
        let errorAlertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        errorAlert.addAction(errorAlertAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // MARK: - NavigationBar Setup Method
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Actions
    @IBAction func forecastButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToForecast", sender: self)
    }
    
    
}




































