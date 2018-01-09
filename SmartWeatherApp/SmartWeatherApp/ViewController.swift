//
//  ViewController.swift
//  SmartWeatherApp
//
//  Created by msushmar on 1/8/18.
//  Copyright © 2018 msushmar. All rights reserved.
//
/// Use this view controller to search and load location weather condition

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// set an instance of searchViewModel and initialize in viewDidload
    private var searchViewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmptyUI() ///sets the screen to blank, as cold start (can enhance by displaying user's current location )
        
        searchViewModel = SearchViewModel()
        
        /// For returning user, screen launch shows the last searched location weather if exists
        if let location = searchViewModel.getLastSearchedLocation() {
            searchWeather(withLocation: location)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// This method fetches the weather of particular location
    ///
    /// - Parameter location: can pass any interested location/ place of type string
    fileprivate func searchWeather(withLocation location: String) {
        searchViewModel.fetchSearchResults(forLocation: location) { (result, error) in
            if let result = result {
                self.updateUI(withResult: result)
            } else if let error = error {
                print("**** failure in fetching search results ***** \(error)")
                /// Update the screen with error alert or message. Also choose to send to metrics using page name for easy tracing
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "", message: "City Not Found. Try a new city", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (ac) in
                      }))
                    self.present(alertVC, animated: true, completion: nil)
                        }
                }
        }
    }

    /// This method updates UI with new values
    ///
    /// - Parameter result: of type SearchResultObject, mostly is the response constructed from web service return
    fileprivate func updateUI(withResult result: WeatherModel) {
            DispatchQueue.main.async {
                    self.city.text = result.city
                    self.country.text = result.country
                    self.weatherType.text = result.weatherDescription
                    self.currentTemperature.text = result.currenttemp
            }
                ///Call downloadImages to fetch images asynchronosly from service
            searchViewModel.downloadImages(withIconId: result.iconId, completion: { (image, error) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.weatherIcon.image = image
                        }
                    } else if let error = error {
                        print("***** error in downloading image \(error) *****")
                    }
            })
    }
    ///Sets default values to labels on UI. Called on view launch
    private func updateEmptyUI() {
        DispatchQueue.main.async {
            self.city.text = ""
            self.country.text = ""
            self.weatherType.text = ""
            self.currentTemperature.text = ""
        }
    }

}
extension ViewController: UISearchBarDelegate {
    
    /// Triggers on clicking search button on keyboard. Takes in the text inside searchBar and uses to call webservice for weather conditions
    ///
    /// - Parameter searchBar: is an instance of searchBar on UI
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder() ///Dismissed the keyboard
        guard var searchText = searchBar.text, !searchText.isEmpty else {
            print("***** search bar is empty *****")
            return }
        searchText = searchText.replacingOccurrences(of: " ", with: ",") /// eg: "Hawthorne US" converts to "Hawthorne,US" for better results
        searchBar.text = "" /// reset the search bar text
        searchWeather(withLocation: searchText)
    }
}

