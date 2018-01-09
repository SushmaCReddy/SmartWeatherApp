//
//  WeatherModel.swift
//  SmartWeatherApp
//
//  Created by msushmar on 1/8/18.
//  Copyright © 2018 msushmar. All rights reserved.
//

import Foundation

typealias ResourceDictionary = Dictionary<String, AnyObject>

class WeatherModel {
    //MARK: - Properties
    
    /// The response dictionary containing the weather information.
    private var responseDictionary: ResourceDictionary = [:]

    /// Initializes a new resource dictionary
    ///
    /// - Parameter dataItems: The resource dictionary, containing details of weather
    init(dataItems: ResourceDictionary) {
        self.responseDictionary = dataItems
    }
    
    lazy var city: String = {
        return responseDictionary["name"] as? String ?? ""
    }()
 
    lazy var country: String = {
        guard let sys = responseDictionary["sys"] as? ResourceDictionary else { return "" }
        return sys["country"] as? String ?? ""
    }()
    
    /// iconId, gives details of weather type (eg: rainy) as id's(10d). Is used to find images
    lazy var iconId: String = {
        guard  let weather = responseDictionary["weather"] as? [ResourceDictionary], let firstItem = weather.first else { return "" }
        return firstItem["icon"] as? String ?? ""
    }()
    
    ///weatherDescription, gives decsription like thunderStorm, rain etc
    lazy var weatherDescription: String = {
        guard  let weather = responseDictionary["weather"] as? [ResourceDictionary], let firstItem = weather.first else { return "" }
        return firstItem["description"] as? String ?? ""
    }()
    
    lazy var currenttemp: String = {
        guard  let main = responseDictionary["main"] as? ResourceDictionary, let temp =  main["temp"] else { return "" }
        return String(describing: temp)
    }()
}
