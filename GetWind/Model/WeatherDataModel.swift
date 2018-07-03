//
//  WeatherDataModel.swift
//  GetWind
//
//  Created by Dima Miro on 26.06.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class WeatherDataModel {
    
    var temperature : Int = 0
    var conditions : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var maxTemperature : Int = 0
    var minTemperature : Int = 0
    var humidity : Int = 0
    var pressure : Int = 0
    var wind : Double = 0
    var clouds : Int = 0
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300, 772...799, 900...903, 905...1000 :
            return "storm"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower"
            
        case 601...700, 903 :
            return "snow"
            
        case 701...771 :
            return "fog"
            
        case 800, 904 :
            return "sunny"
            
        case 801...804 :
            return "cloudy"
            
        default :
            return "dunno"
        }
        
    }
    
}
