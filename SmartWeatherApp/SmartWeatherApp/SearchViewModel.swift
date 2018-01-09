//
//  SearchViewModel.swift
//  SmartWeatherApp
//
//  Created by msushmar on 1/9/18.
//  Copyright © 2018 msushmar. All rights reserved.
//

import Foundation
import UIKit
class SearchViewModel: NSObject {
    let searchModel: SearchModel
    override init() {
        /// Initialize new search Model Object
        searchModel = SearchModel()
    }
    
    /// This method returns the last searched location stored in user defaults
    func getLastSearchedLocation() -> String? {
        guard let location = UserDefaults.standard.string(forKey: searchModel.recentlySearchedLocationKey),
            !location.isEmpty else {
                return nil
        }
        return location
    }
    /// Fetch search results, based on user interested location search
    func fetchSearchResults(forLocation location: String, completion: @escaping (_ result: WeatherModel?, _ error: Error?) -> Void) {
        do {
            try  searchModel.fetchSearchResults(forLocation: location) { (result) in
                switch result {
                case let .success(res):
                    completion(res, nil)
                case let .failure(err):
                    completion(nil, err)
                    ///Use it to send Metrics for call failure. (WebServiceError has required parameters for metrics)
                }
            }
            
        }
        catch let error {
            print(error)
        }
    }
    
    /// Fetch Images from service based on iconId's
    func downloadImages(withIconId iconId: String, completion: @escaping(_ image: UIImage?, _ error: Error?) -> Void) {
        do {
            try searchModel.downloadImages(withIconId: iconId, withCompletion: { (result) in
                switch result {
                case let .success(image):
                    completion(image, nil)
                case let .failure(err):
                    completion(nil, err)
                    ///Use it to send Metrics for call failure. (WebServiceError has required parameters for metrics)
                }
            })
        }
        catch let error {
            print(error)
        }
    }
}
