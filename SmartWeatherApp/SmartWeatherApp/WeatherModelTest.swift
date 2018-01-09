//
//  WeatherModelTest.swift
//  SmartWeatherAppTests
//
//  Created by msushmar on 1/9/18.
//  Copyright © 2018 msushmar. All rights reserved.
//

import XCTest

class WeatherModelModelTest: XCTestCase {
   
    var mockData: Dictionary<String, AnyObject> = [:]
    override func setUp() {
        super.setUp()
        getMockWeatherJson()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func getMockWeatherJson() {
     
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
       
    }
    func testLazyVariableValues() {
        
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
