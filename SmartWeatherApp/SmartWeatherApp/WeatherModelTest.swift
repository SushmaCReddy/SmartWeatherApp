//
//  WeatherModelTest.swift
//  SmartWeatherAppTests
//
//  Created by msushmar on 1/9/18.
//  Copyright © 2018 msushmar. All rights reserved.
//
/// Use this file to test WeatherModel file (To see if it is correctly taking values from response Dictionary)
import XCTest
@testable import SmartWeatherApp

class WeatherModelTest: XCTestCase {
   
    var mockData: ResourceDictionary = [:]
    var mockWeatherModel : WeatherModel!

    override func setUp() {
        super.setUp()
        self.setMockWeatherJson()
        mockWeatherModel = WeatherModel(dataItems: mockData)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// This method reads mock weather.json from local and stores into mockData
    func setMockWeatherJson() {
     
        if let configPath = Bundle.main.path(forResource: "Weather", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: configPath), options: Data.ReadingOptions.mappedIfSafe)
                let parsedJson = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
                if let parsedJSON = parsedJson {
                    mockData = parsedJSON
                } else {
                    print("Error while parsing data")
                }
            } catch let dataError as NSError {
                print("Error while getting data from main bundle: \(dataError.localizedDescription)")
            }
        }
        else {
            print("File doesn't exist")
        }
    }
    func testInit() {
        let mockModel = WeatherModel(dataItems: mockData)
        ///Test to see response dictionary is not empty, if sucessfully initialized
         XCTAssertTrue(!mockModel.responseDictionary.isEmpty)
    }
    ///MARK: - Methods
    
    ///All the methods test the lazy variables in WeatherModel file, if they are returning correct strings
    func testCityValues() {
        XCTAssertEqual(mockWeatherModel.city, "Torrance")
    }
    func testCountryValue() {
        XCTAssertEqual(mockWeatherModel.country, "US")
    }
    func testIconIdValue() {
        XCTAssertEqual(mockWeatherModel.iconId, "10n")
    }
    func testWeatherTypeValue() {
        XCTAssertEqual(mockWeatherModel.weatherDescription, "light rain")
    }
    func testCurrentTemperatureValue() {
        XCTAssertEqual(mockWeatherModel.currenttemp, "289.53")
    }

    
}
