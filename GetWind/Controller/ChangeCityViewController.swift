//
//  ChangeCityViewController.swift
//  GetWind
//
//  Created by Dima Miro on 03.07.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    //Delegate variables
    var delegate : ChangeCityDelegate?

    
    @IBOutlet weak var changeCityTextField: UITextField! {
        didSet {
            //Height changing
            changeCityTextField.frame.size.height = 44
            //Left Padding
            changeCityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: changeCityTextField.frame.height))
            changeCityTextField.leftViewMode = .always
            //Right Padding
            changeCityTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: changeCityTextField.frame.height))
            changeCityTextField.rightViewMode = .always
        }
    }
    @IBOutlet weak var getWindButton: UIButton! {
        didSet {
            getWindButton.layer.cornerRadius = 6
        }
    }
    
    
    @IBAction func getWindPressed(_ sender: AnyObject) {
        
        // 1 - Get the city name user entered in searchBar
        let cityName = changeCityTextField.text!
        // 2 - If we have a delegate set, call the method userEnteredANewCityName
        if cityName != "" {
            delegate?.userEnteredANewCityName(city: cityName)
        }
        // 3 - Dismiss ChangeCityViewController to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
