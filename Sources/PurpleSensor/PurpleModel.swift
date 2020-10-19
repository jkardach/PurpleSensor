//
//  PurpleModel.swift
//  purpleAir
//
//  Created by jim kardach on 10/15/20.
//

import Foundation

@objc public class PurpleModel: NSObject {
    @objc public var name: String = ""
    @objc public var humidity: String = ""
    @objc public var temp: String = ""
    @objc public var pressure: String = ""
    @objc public var PMcurrent: String = ""
    
    @objc public var PM: Double = 0.0
    @objc public var PM10min: Double = 0.0
    @objc public var PM30min: Double = 0.0
    @objc public var PM1hr: Double = 0.0
    @objc public var PM6hr: Double = 0.0
    @objc public var PM24hr: Double = 0.0
    @objc public var PM1week: Double = 0.0
    
    @objc public var AQ: Double {
        get {
            return aqiFromPM(pm: PM)
        }
    }
    @objc public var AQDescription: String {
        get {
            return getAQIDescription(aqi: AQ)
        }
    }
    @objc public var AQMessage: String {
        get {
            return getAQIMessage(aqi: AQ)
        }
    }
    
    @objc public var AQ10min: Double {
        get {
            return aqiFromPM(pm: PM10min)
        }
    }
    @objc public var AQ10minDescription: String {
        get {
            return getAQIDescription(aqi: AQ10min)
        }
    }
    @objc public var AQ10minMessage: String {
        get {
            return getAQIMessage(aqi: AQ10min)
        }
    }
    
    @objc public var AQ30min: Double {
        get {
            return aqiFromPM(pm: PM30min)
        }
    }
    @objc public var AQ30minDescription: String {
        get {
            return getAQIDescription(aqi: AQ30min)
        }
    }
    @objc public var AQ30minMessage: String {
        get {
            return getAQIMessage(aqi: AQ30min)
        }
    }
    
    @objc public var AQ1hr: Double {
        get {
            return aqiFromPM(pm: PM1hr)
        }
    }
    @objc public var AQ1hrDescription: String {
        get {
            return getAQIDescription(aqi: AQ1hr)
        }
    }
    @objc public var AQ1hrMessage: String {
        get {
            return getAQIMessage(aqi: AQ1hr)
        }
    }
    
    @objc public var AQ6hr: Double {
        get {
            return aqiFromPM(pm: PM6hr)
        }
    }
    @objc public var AQ6hrDescription: String {
        get {
            return getAQIDescription(aqi: AQ6hr)
        }
    }
    @objc public var AQ6hrMessage: String {
        get {
            return getAQIMessage(aqi: AQ6hr)
        }
    }
    
    @objc public var AQ24hr: Double {
        get {
            aqiFromPM(pm: PM24hr)
        }
    }
    @objc public var AQ24hrDescription: String {
        get {
            return getAQIDescription(aqi: AQ24hr)
        }
    }
    @objc public var AQ24hrMessage: String {
        get {
            return getAQIMessage(aqi: AQ24hr)
        }
    }
    
    @objc public var AQ1week: Double {
        get {
            return aqiFromPM(pm: PM1week)
        }
    }
    @objc public var AQ1weekDescription: String {
        get {
            return getAQIDescription(aqi: AQ1week)
        }
    }
    @objc public var AQ1weekMessage: String {
        get {
            return getAQIMessage(aqi: AQ1week)
        }
    }
    
    
    
    func aqiFromPM(pm: Double) -> Double {
        
        if pm > 350.5 {
            return calcAQI(Cp: pm, lh: 500, ll: 401, BPh: 500, BPI: 350.5);
        } else if pm > 250.5 {
            return calcAQI(Cp: pm, lh: 400, ll: 301, BPh: 350.4, BPI: 250.5);
        } else if pm > 150.5 {
            return calcAQI(Cp: pm, lh: 300, ll: 201, BPh: 250.4, BPI: 150.5);
        } else if pm > 55.5 {
            return calcAQI(Cp: pm, lh: 200, ll: 151, BPh: 150.4, BPI: 55.5);
        } else if pm > 35.5 {
            return calcAQI(Cp: pm, lh: 150, ll: 101, BPh: 55.4, BPI: 35.5);
        } else if pm > 12.1 {
            return calcAQI(Cp: pm, lh: 100, ll: 51, BPh: 35.4, BPI: 12.1);
        } else if pm >= 0 {
            return calcAQI(Cp: pm, lh: 50, ll: 0, BPh: 12, BPI: 0);
        } else {return 0.0}
    }
    
    func calcAQI(Cp: Double, lh: Double, ll: Double, BPh: Double, BPI: Double) -> Double {
        let a = lh - ll
        let b = BPh - BPI
        let c = Cp - BPI
        return round((a/b)*c + ll)
    }
    
    func bplFromPM(pm: Double) -> Int {
        if pm > 350.5 {
            return 401
        } else if pm > 250.5 {
            return 301;
        } else if pm > 150.5 {
            return 201;
        } else if pm > 55.5 {
            return 151;
        } else if pm > 35.5 {
            return 101;
        } else if pm > 12.1 {
            return 51;
        } else if pm >= 0 {
            return 0;
        } else {
            return 0;
        }
    }
    
    func bphFromPM(pm: Double) -> Int {
        if pm > 350.5 {
            return 500;
        } else if pm > 250.5 {
            return 500;
        } else if pm > 150.5 {
            return 300;
        } else if pm > 55.5 {
            return 200;
        } else if pm > 35.5 {
            return 150;
        } else if pm > 12.1 {
            return 100;
        } else if pm >= 0 {
            return 50;
        } else {
            return 0;
        }
        
    }
    
    func getAQIDescription(aqi: Double) -> String {
        if aqi >= 401 {
            return "Hazardous";
        } else if aqi >= 301 {
            return "Hazardous";
        } else if aqi >= 201 {
            return "Very Unhealthy";
        } else if aqi >= 151 {
            return "Unhealthy";
        } else if aqi >= 101 {
            return "Unhealthy for Sensitive Groups";
        } else if aqi >= 51 {
            return "Moderate";
        } else if aqi >= 0 {
            return "Good";
        } else {
            return "Error";
        }
    }
    
    func getAQIMessage(aqi: Double) -> String {
        if aqi >= 401 {
            return ">401: Health alert: everyone may experience more serious health effects";
        } else if aqi >= 301 {
            return "301-400: Health alert: everyone may experience more serious health effects";
        } else if aqi >= 201 {
            return "201-300: Health warnings of emergency conditions. The entire population is more likely to be affected. ";
        } else if aqi >= 151 {
            return "151-200: Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects.";
        } else if aqi >= 101 {
            return "101-150: Members of sensitive groups may experience health effects. The general public is not likely to be affected.";
        } else if aqi >= 51 {
            return "51-100: Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.";
        } else if aqi >= 0 {
            return "0-50: Air quality is considered satisfactory, and air pollution poses little or no risk";
        } else {
            return "Error";
        }
    }
    
}
