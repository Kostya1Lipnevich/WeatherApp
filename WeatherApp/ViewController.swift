//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kostya LIpnevich on 28.03.22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationName: UILabel! {
        didSet{
            locationName.text = "City"
            locationName.textAlignment = .center
            locationName.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 17)
            locationName.numberOfLines = 0
        }
    }
    @IBOutlet weak var temperature: UILabel! {
        didSet {
            temperature.text = "C"
            temperature.textAlignment = .center
            temperature.font = .systemFont(ofSize: 25)
            temperature.numberOfLines = 1
        }
        
    }
    @IBOutlet weak var time: UILabel! {
        didSet {
            time.text = "LocalTime"
            time.textAlignment = .center
            time.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 15)
            time.numberOfLines = 1
        }
    }
    @IBOutlet weak var wind: UILabel! {
        didSet {
            wind.text = "Wind Speed"
            wind.textAlignment = .left
            wind.font = .systemFont(ofSize: 15)
            wind.numberOfLines = 1
            
        }
    }
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    //MARK: Functions

  
    }

extension ViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "http://api.weatherapi.com/v1/current.json?key=154073d6c5fb4aedb41192502222803&q=\(searchBar.text!)&aqi=no"
        let url = URL(string: urlString)
        
        
        var locationName: String?
        var temperature: Double?
        var localTime: String?
        var windSpeed: Double?
        
        
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, responser, error) in
            
            do {
                let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                 as! [String: AnyObject]
              
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
                    
                }
                
                if let location = json["location"] {
                    localTime = location["localtime"] as? String
                }
                
                if let current = json["current"] {
                    windSpeed = current["wind_kph"] as? Double
                }
                
                DispatchQueue.main.async {
                    self?.locationName.text = locationName
                    self?.temperature.text = "\(temperature!)С"
                    self?.time.text = localTime
                    self?.wind.text = "\(windSpeed!) Км/ч"
                }
                
                
                
            }
            catch let jsonErorr {
                print(jsonErorr)
            }
        }
        task.resume()
    }
}


