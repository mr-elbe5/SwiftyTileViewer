/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa
import SwiftyMacViewExtensions

class HelpViewController: NSViewController {
    
    let texts = ["Swifty Tile Viewer is a tool to identify and view map tiles like those of OpenStreetMap.",
                 "Although this app targets primarily OpenStreetMap tiles, this app is not endorsed by or affiliated with the OpenStreetMap Foundation.",
                 "The server must be set in 'Preferences', where you enter a host address. For loading tiles, this address (which ends with a slash like 'https://maps.yourhost.tld/hot/') will be completed with a pattern of 'z/x/y.png', where z is the zoom level and x and y the tile coordinates.",
                 "In 'Preferences' you can also set default limiting bounds for your tile area. Coordinates can be set from -180 to 180 longitude and -85 to 85 latitude.",
                 "These bounds are the default for the coordinate bounds in the control area of the main window.",
                 "In 'Preferences' you should also set an appropriate load timeout, which should correspond to the 'not found' timeout on your server (e.g ModTileMissingRequestTimeout for Apache).",
                 "In the control area you can set the zoom level, find the limits of tile numbers (after setting bounds and zoom level) and view a single tile.",
                 "You can also use this tool to load a series of tiles for generating meta tiles on your own server.",
                 "Important:",
                 "Viewing a tile series can involve many tiles and take very long. As it creates a heavy work load on the server, you should never start this on a server, where you don't have respective rights (like on your own).",
                 "If a tile request returns a 'not found (404)', it may not have been rendered yet and is set aside.",
                 "You can try to load only these failed tiles at the end with the respective button.",
                 "You can stop a bulk download at any time.",
                 "The results of downloads are shown in the log window at the bottom."]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 800, height: 270)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        let font = NSFont.systemFont(ofSize: 14)
        for text in texts{
            let field = NSTextField(wrappingLabelWithString: text)
            field.font = font
            stack.addArrangedSubview(field)
        }
        view.addSubview(stack)
        stack.fillSuperview(insets: Insets.defaultInsets)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
