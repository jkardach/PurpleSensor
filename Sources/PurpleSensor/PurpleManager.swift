//
//  PurpleManager.swift
//  purpleAir
//
//  Created by jim kardach on 10/15/20.
//

import Foundation

@objc public protocol UpdatePurpleDelegate {
    func didUpdatePurple(_ purple: PurpleModel)
    func didFailWithError(_ error: Error)
}

public class PurpleManager:NSObject {
    
    let purpleURL = "https://www.purpleair.com/json?show="
    @objc public var delegate: UpdatePurpleDelegate?
    
    @objc public override init() {}
    
    @objc public func performRequest(id: String, thinkspeakKey: String) {
        if let url = URL(string: purpleURL + id + "&key=" + thinkspeakKey) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let purple = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePurple(purple)
                    }
                }
            }
            task.resume()
        }
    }
    
    @objc public func performDistRequest(id: String, thinkspeakKey: String, lat: Double, lon: Double) {
        if let url = URL(string: purpleURL + id + "&key=" + thinkspeakKey) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let purple = self.parseBigJSON(safeData, lat: lat, lon: lon) {
                        self.delegate?.didUpdatePurple(purple)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ purpleData: Data) -> PurpleModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PurpleData.self, from: purpleData)
            
            let purple = PurpleModel()
  
            let values = decodedData.results[0]
            let statString = values.Stats  // JSON String
            let dict = convertStringToDictionary(text: statString!)
            
            purple.name = values.Label
            purple.humidity = values.humidity ?? "error"
            purple.temp = values.temp_f ?? "error"
            purple.pressure = values.pressure ?? "error"
            
            
            purple.PM = dict!["v"] as? Double ?? 0.0
            purple.PM10min = dict!["v1"] as? Double ?? 0.0
            purple.PM30min = dict!["v2"] as? Double ?? 0.0
            purple.PM1hr = dict!["v3"] as? Double ?? 0.0
            purple.PM6hr = dict!["v4"] as? Double ?? 0.0
            purple.PM24hr = dict!["v5"] as? Double ?? 0.0
            purple.PM1week = dict!["v6"] as? Double ?? 0.0
            
            return purple

            
        } catch {
            print(error)
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func parseBigJSON(_ purpleData: Data, lat: Double, lon: Double) -> PurpleModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PurpleData.self, from: purpleData)
            
            
            var sensors = [PurpleModel]()
            for values in decodedData.results {
                let purple = PurpleModel()
                let statString = values.Stats
                let dict = convertStringToDictionary(text: statString!)
                purple.name = values.Label
                purple.humidity = values.humidity ?? "error"
                purple.temp = values.temp_f ?? "error"
                purple.pressure = values.pressure ?? "error"
                
                purple.PM = dict!["v"] as? Double ?? 0.0
                purple.PM10min = dict!["v1"] as? Double ?? 0.0
                purple.PM30min = dict!["v2"] as? Double ?? 0.0
                purple.PM1hr = dict!["v3"] as? Double ?? 0.0
                purple.PM6hr = dict!["v4"] as? Double ?? 0.0
                purple.PM24hr = dict!["v5"] as? Double ?? 0.0
                purple.PM1week = dict!["v6"] as? Double ?? 0.0
                purple.lon = values.Lon
                purple.lat = values.Lat
                purple.distance = distance(lat1: lat, lon1: lon, lat2: values.Lat, lon2: values.Lon)  // adds distance to each record
                sensors.append(purple)
            }
            
            sensors.sort {
                $0.distance < $1.distance
            }
            
            return sensors[0]

            
        } catch {
            print(error)
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let a = 0.5 - cos((lat2 - lat1)*Double.pi)/2 + cos(lat1*Double.pi)*cos(lat2*Double.pi)*(1-cos((lon2-lon1)*Double.pi))/2.0
        return 12742 * asin(sqrt(a))
        // a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p)*cos(lat2*p) * (1-cos((lon2-lon1)*p)) / 2
        // return 12742 * asin(sqrt(a))
    }
    
}
