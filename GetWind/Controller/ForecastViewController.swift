//
//  ForecastViewController.swift
//  GetWind
//
//  Created by Dima Miro on 04.07.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForecastCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
}

class ForecastViewController: UIViewController {
    // Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    //Variables
    var currentLocationFromWeatherVC : String = ""
    var forecastDataArray : [ForecastCellData] = []
    
    // Common Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
    let APP_ID = "21130cc260da520ac6319903ce5f294e"
    
    // Declare instance variables here
    let forecastDataModel = ForecastDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getForecast(url: WEATHER_URL)
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        self.forecastTableView.tableFooterView = UIView()
    }
    //MARK: - Forecast Networking
    //Here is getForecast method
    
    func getForecast (url: String) {
        let params : [String : String] = ["q" : currentLocationFromWeatherVC, "appid" : APP_ID]
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the forecast data.")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateForecast(json: weatherJSON)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.locationLabel.text = "Connections issues"
            }
            
        }
        
    }
    
    //MARK: - Forecast JSON Parsing
    //Here is updateForecast method
    func updateForecast (json: JSON) {
        print("Update forecast: \(json["cod"])")
        let requestCode = json["cod"].intValue
        if requestCode == 200 {
            let cnt = json["cnt"].intValue
            for index in 0...(cnt-1) {
                let weatherConditions = json["list"][index]["weather"][0]["id"].intValue
                let dateInMiliseconds = json["list"][index]["dt"].intValue
                let mainTempResult = json["list"][index]["temp"]["day"].doubleValue
                let maxTempResult = json["list"][index]["temp"]["max"].doubleValue
                let minTempResult = json["list"][index]["temp"]["min"].doubleValue
                
                let forecastData = ForecastCellData(conditionId: weatherConditions, date: dateInMiliseconds, mainTemp: mainTempResult, maxTemp: maxTempResult, minTemp: minTempResult)
                forecastDataArray.append(forecastData)
            }
            
            updateUIWithForecast()
        } else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    // MARK: - Farecast Data Object
    
    //MARK - UI Update
    func updateUIWithForecast() {
        print("UI Update: \(currentLocationFromWeatherVC)")
        locationLabel.text = currentLocationFromWeatherVC
        self.forecastTableView.reloadData()
    }
    
    // MARK - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(forecastDataArray.count)
        return forecastDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastData = forecastDataArray[indexPath.row]
        
        
        //Weekday detection
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastCustomCell
        
        let weatherIconName = forecastDataModel.updateWeatherIcon(condition: forecastData.conditionId)
        cell.forecastImage.image = UIImage(named: weatherIconName)
        
        let date = Date(timeIntervalSince1970: (Double(forecastData.date)))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: date)
        cell.weekdayLabel.text = "\(weekday)"
        
        
        cell.mainTempLabel.text = "\(Int(forecastData.mainTemp - 273.5))"
        cell.maxTempLabel.text = "Max: \(Int(forecastData.maxTemp - 273.5))°C"
        cell.minTempLabel.text = "Min: \(Int(forecastData.minTemp - 273.5))°C"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 56.0
    }

}







