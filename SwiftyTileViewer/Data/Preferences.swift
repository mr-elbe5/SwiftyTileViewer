/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation



protocol PreferencesDelegate {
    func preferencesChanged()
}

class Preferences: Identifiable, Codable{
    
    static var shared = Preferences()
    
    enum CodingKeys: String, CodingKey {
        case minLongitude
        case maxLongitude
        case minLatitude
        case maxLatitude
        case urlPattern
        case loadTimeout
    }
    var minLongitude : Double = -180.0
    var maxLongitude : Double = 180.0
    var minLatitude : Double = -80.0
    var maxLatitude : Double = 80.0
    var urlPattern : String = ""
    var loadTimeout : Int = 30*60
    
    var delegate : PreferencesDelegate? = nil

    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        minLongitude = try values.decodeIfPresent(Double.self, forKey: .minLongitude) ?? -180.0
        maxLongitude = try values.decodeIfPresent(Double.self, forKey: .maxLongitude) ?? 180.0
        minLatitude = try values.decodeIfPresent(Double.self, forKey: .minLatitude) ?? -80.0
        maxLatitude = try values.decodeIfPresent(Double.self, forKey: .maxLatitude) ?? 80.0
        urlPattern = try values.decodeIfPresent(String.self, forKey: .urlPattern) ?? ""
        loadTimeout = try values.decodeIfPresent(Int.self, forKey: .loadTimeout) ?? 30*60
        save()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minLongitude, forKey: .minLongitude)
        try container.encode(maxLongitude, forKey: .maxLongitude)
        try container.encode(minLatitude, forKey: .minLatitude)
        try container.encode(maxLatitude, forKey: .maxLatitude)
        try container.encode(urlPattern, forKey: .urlPattern)
        try container.encode(loadTimeout, forKey: .loadTimeout)
    }
    
    static func load(){
        if let storedString = UserDefaults.standard.value(forKey: "osmViewerPreferences") as? String {
            if let history : Preferences = Preferences.fromJSON(encoded: storedString){
                Preferences.shared = history
            }
        }
        else{
            print("no saved data available for preferences")
            Preferences.shared = Preferences()
        }
    }
    
    func minTileX(zoom: Int) -> Int{
        return Int(floor((minLongitude + 180) / 360.0 * pow(2.0, Double(zoom))))
    }
    
    func maxTileX(zoom: Int) -> Int{
        return Int(floor((maxLongitude + 180) / 360.0 * pow(2.0, Double(zoom))))
    }
    
    func minTileY(zoom: Int) -> Int{
        return Int(floor((1 - log( tan( minLatitude * Double.pi / 180.0 ) + 1 / cos( minLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
    }
    
    func maxTileY(zoom: Int) -> Int{
        return Int(floor((1 - log( tan( maxLatitude * Double.pi / 180.0 ) + 1 / cos( maxLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
    }
    
    func save(){
        let storeString = toJSON()
        UserDefaults.standard.set(storeString, forKey: "osmViewerPreferences")
        delegate?.preferencesChanged()
    }
}


