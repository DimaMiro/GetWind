//
//  ForecastDataModel.swift
//  GetWind
//
//  Created by Dima Miro on 06.07.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ForecastCellData {
    
    var conditionId: Int
    var date: Int
    var mainTemp: Double
    var maxTemp: Double
    var minTemp: Double
    
    
    init(conditionId: Int, date: Int, mainTemp: Double, maxTemp: Double, minTemp: Double) {
        self.conditionId = conditionId
        self.date = date
        self.mainTemp = mainTemp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
    
}

class ForecastDataModel {
    
    
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
