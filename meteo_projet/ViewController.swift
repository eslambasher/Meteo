//
//  ViewController.swift
//  meteo_projet
//
//  Created by Eslam ABDULMOLA on 04/04/17.
//  Copyright © 2017 Eslam ABDULMOLA. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var myList: UITableView!
    
    let locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    static var table = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data()
        print(ViewController.table)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func data()  {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
            
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            userLatitude  = locationManager.location?.coordinate.latitude
            userLongitude  = locationManager.location?.coordinate.longitude
        }
      
        let lati:String = "\(self.userLatitude),"
        let long:String = "\(self.userLongitude)"
        let log = long.replacingOccurrences(of: "Optional(", with: "", options: .literal, range: nil)
        let Longitude = log.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        let lati1 = lati.replacingOccurrences(of: "Optional(", with: "", options: .literal, range: nil)
        let Latitude = lati1.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        let url = "https://api.darksky.net/forecast/74318c855d490ef835c35ae3556b28e4/" + Latitude + Longitude  + "?exclude=minutely,daily,flags,alerts"
        URLSession.shared.dataTask(with: NSURL(string: url) as! URL) { data, response, error in
            if (error != nil)
            {
                print("ERROR")
            }
            else
            {
                self.jsonURL(jsonData: data!)
            }
            }.resume()
    }
    
    func jsonURL (jsonData: Data)
    {
        
     let Myjson = try? JSONSerialization.jsonObject(with: jsonData,  options: []) as! [String:Any]
        if let hourly = Myjson?["hourly"] as? [String: Any]
            {
                if let date = hourly["data"] as? NSArray
                {
                    for i in 0..<25
                    {
                        let test = date[i] as? [String: Any]
                        if let temp = test?["apparentTemperature"] {
                            let tempe:String = "\(temp)"
                            ViewController.table += [(tempe)]
                        }
                    }
                }
                    
            }
        print(ViewController.table)
            self.do_table_refresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (ViewController.table.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text =  ViewController.table[indexPath.row]
        
        return (cell)
    }
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: { 
            self.myList.reloadData()
            return
            })
    }

}

