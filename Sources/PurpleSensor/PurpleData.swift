//
//  PurpleData.swift
//  purpleAir
//
//  Created by jim kardach on 10/15/20.
//

import Foundation

public struct PurpleData: Codable {
    let mapVersion: String?
    let baseVersion: String?
    let mapVersionString: String?
    let results: [Purple]
}

public struct Purple: Codable {
    let ID: Int
    let Label: String
    let PM2_5Value: String?
    let humidity: String?
    let temp_f: String?
    let pressure: String?
    let Stats: String?
}


public struct Statistics: Codable {
    let v: Double
    let v1: Double
    let v2: Double
    let v3: Double
    let v4: Double
    let v5: Double
    let v6: Double
    
}

