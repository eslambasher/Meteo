//
//  ViewController.swift
//  meteo_projet
//
//  Created by Eslam ABDULMOLA on 04/04/17.
//  Copyright © 2017 Eslam ABDULMOLA. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
            
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            userLatitude  = locationManager.location?.coordinate.latitude
            userLongitude  = locationManager.location?.coordinate.longitude
            
            let lati:String = "\(userLatitude),"
            let long:String = "\(userLongitude)"
            let log = long.replacingOccurrences(of: "Optional(", with: "", options: .literal, range: nil)
            let Longitude = log.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            let lati1 = lati.replacingOccurrences(of: "Optional(", with: "", options: .literal, range: nil)
            let Latitude = lati1.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            let url = URL(string: "https://api.darksky.net/forecast/74318c855d490ef835c35ae3556b28e4/" + Latitude + Longitude  + "?exclude=minutely,daily,flags,alerts")
            let task = URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
                if error != nil
                {
                    print("ERROR");
                }
                else
                {
                    if let content = data
                    {
                        do
                        {
                            let Myjson = try JSONSerialization.jsonObject(with: content,  options: []) as! [String:Any]
                            if let hourly = Myjson["hourly"] as? [String: Any]
                            {
                                if let date = hourly["data"] as? NSArray
                                {
    
                                    for i in 0..<25
                                    {
                                        let test = date[i] as? [String: Any]
                                        if let temp = test?["apparentTemperature"] {
                                            print(temp)
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        catch
                        {
                            
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

