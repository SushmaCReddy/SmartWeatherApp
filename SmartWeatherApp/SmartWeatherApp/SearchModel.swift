//
//  SearchModel.swift
//  SmartWeatherApp
//
//  Created by msushmar on 1/8/18.
//  Copyright © 2018 msushmar. All rights reserved.
//

import Foundation
import UIKit

///Genric completion Handler
public typealias ServiceCompletionHandler<T> = (ServiceResult<T>) -> ()

///Generic Enum, can be used as completion handler for any
public enum ServiceResult<T> {
    case success(T)
    case failure(Error)
}
class SearchModel: NSObject, URLSessionDelegate {
    
    var recentlySearchedLocationKey = "recentlySearchedLocation" ///Recently searched location Key name used to set in user defaults cache

    /// Fetch search results, based on user interested location search
    ///
    /// - Parameters:
    ///   - location: of type String, that specifies user interested location
    ///   - completion: A closure, of type XCMSServiceCompletionHandler, that will be executed once the call is finished; it contains a ServiceResult object that: if successful will contain an Array of Any items, else it will contain an error.
    /// - Throws: error is thrown if api isn't found in app config
    func fetchSearchResults(forLocation location: String, withCompletion completion: @escaping ServiceCompletionHandler<WeatherModel>)  throws -> Void {
        do {
            let config = AppConfiguration.sharedInstance
            let endPoint = try config.endPoints?.globalAPIGatewayEndPoint()
            let api = try config.endPoints?.searchAPIEndpoint(location: location)
            let urlParams: [String: String]? = ["q" : "\(location)", "appid" : config.getAppKey()!]
            WebService().execute(endPoint: endPoint, api: api, urlParams: urlParams, successCallback: { (response: WebServiceResponse) in
                ///store the recently searched location in user defaults
                UserDefaults.standard.set(location, forKey: self.recentlySearchedLocationKey)
                guard let responseDictionary = self.parseToDictionary(response.body) else {
                    print(" : Fail to convert data to json \(response.body)")
                    return
                }
                let result = WeatherModel(dataItems: responseDictionary)
                completion(.success(result))
            }, errorCallback: { (serviceError: WebServiceError?) in
                //error code
                if let serviceError = serviceError {
                    completion(.failure(serviceError))
                }
            })
        } catch let error {
            print(": Error in search service : \(error)")
            completion(.failure(error))
        }
    }
    
    /// Fetch Images from service based on iconId's
    ///
    /// - Parameters:
    ///   - iconId: of type String, mention if its rainy, stormy etc
    ///   - completion: A closure, of type XCMSServiceCompletionHandler, that will be executed once the call is finished; it contains a ServiceResult object that: if successful will contain an Array of Any items, else it will contain an error.
    /// - Throws: error is thrown if api isn't found in app config
    func downloadImages(withIconId iconId: String, withCompletion completion: @escaping ServiceCompletionHandler<UIImage>) throws -> Void {
        do {
            let config = AppConfiguration.sharedInstance
            let endPoint = try config.endPoints?.globalAPIGatewayEndPoint()
            let api = try config.endPoints?.weatherIconAPIEndpoint(iconId: iconId)
            WebService().execute(endPoint: endPoint, api: api, urlParams: nil, successCallback: { (response: WebServiceResponse) in
                if let image = UIImage(data: response.body) {
                    completion(.success(image))
                }
                
            }, errorCallback: { (serviceError: WebServiceError?) in
                //error code
                if let serviceError = serviceError {
                    completion(.failure(serviceError))
                }
            })
        } catch let error {
            print(": Error in search service : \(error)")
            completion(.failure(error))
        }
    }
    
    /// Parses type Data to Dictionary by serializing json object
    ///
    /// - Parameter data: of type Data, that wanted to get converted to Dictionary
    /// - Returns: of type Dictionary, returned after conversion
    private func parseToDictionary(_ data: Data) -> [String:AnyObject]? {
        let parsedJson = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
        
        if parsedJson != nil {
            return parsedJson!
        }
        
        return nil
    }
    
}
