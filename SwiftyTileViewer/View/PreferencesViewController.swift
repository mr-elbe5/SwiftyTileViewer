/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa
import SwiftyMacViewExtensions

class PreferencesViewController:ViewController {
    
    var minLongitudeField = NSTextField(string: String(Preferences.shared.minLongitude))
    var maxLongitudeField = NSTextField(string: String(Preferences.shared.maxLongitude))
    var minLatitudeField = NSTextField(string: String(Preferences.shared.minLatitude))
    var maxLatitudeField = NSTextField(string: String(Preferences.shared.maxLatitude))
    var urlPatternField = NSTextField(string: Preferences.shared.urlPattern)
    var loadTimeoutField = NSTextField(string: String(Preferences.shared.loadTimeout))
    
    var window : NSWindow!
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 220)
        let okButton = NSButton(title: "Save", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Min. Longitude:", views: [minLongitudeField])
        grid.addLabeledRow(label: "Max. Longitude:", views: [maxLongitudeField])
        grid.addLabeledRow(label: "Min. Latitude:", views: [minLatitudeField])
        grid.addLabeledRow(label: "Max. Latitude:", views: [maxLatitudeField])
        grid.addLabeledRow(label: "URL Pattern (see help text!):", views: [urlPatternField])
        grid.addLabeledRow(label: "Load timeout [sec]:", views: [loadTimeoutField])
        view.addSubview(grid)
        grid.placeBelow(anchor: view.topAnchor)
        let buttonGrid = NSGridView()
        buttonGrid.addRow(with: [okButton])
        view.addSubview(buttonGrid)
        buttonGrid.placeBelow(view: grid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func save(){
        var error : String = ""
        let minLongitude : Double = minLongitudeField.doubleValue
        let maxLongitude : Double = maxLongitudeField.doubleValue
        let minLatitude : Double = minLatitudeField.doubleValue
        let maxLatitude : Double = maxLatitudeField.doubleValue
        let urlPattern : String = urlPatternField.stringValue
        let loadTimeout : Int = Int(loadTimeoutField.intValue)
        if minLongitude < -180{
            error.append("Min. longitude must be greater or equal -180.\n")
        }
        if maxLongitude > 180{
            error.append("Max. longitude must be less or equal 180.\n")
        }
        if minLongitude > maxLongitude{
            error.append("Max. longitude must be greater than min. longitude.\n")
        }
        if minLatitude < -85.0{
            error.append("Min. latitude must be greater or equal -85.\n")
        }
        if maxLatitude > 85.0{
            error.append("Max. latitude must be less or equal 85.\n")
        }
        if minLatitude > maxLatitude{
            error.append("Max. latitude must be greater than min. latitude.\n")
        }
        if urlPattern.isEmpty{
            error.append("The url pattern must not be empty.\n")
        }
        else if !urlPattern.hasSuffix("/"){
            error.append("The url pattern must end with a slash '/'.\n")
        }
        if loadTimeout <= 0{
            error.append("You have to set a valid load timeout.\n")
        }
        if !error.isEmpty{
            let alert = NSAlert()
            alert.messageText = "Please correct your entries:"
            alert.informativeText = error
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: self.window, completionHandler: nil)
            return
        }
        Preferences.shared.minLongitude = minLongitude
        Preferences.shared.maxLongitude = maxLongitude
        Preferences.shared.minLatitude = minLatitude
        Preferences.shared.maxLatitude = maxLatitude
        Preferences.shared.urlPattern = urlPattern
        Preferences.shared.loadTimeout = loadTimeout
        Preferences.shared.save()
        if let window = view.window{
            window.close()
        }
    }
    
}
