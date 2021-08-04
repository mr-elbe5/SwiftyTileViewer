/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class MapSplitViewController: NSSplitViewController {
    
    private let splitViewRestorationIdentifier = "de.elbe5.restorationId:mapSplitViewController"
    
    lazy var mapController = MapViewController()
    lazy var logController = LogViewController()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        splitView.dividerStyle = .paneSplitter
        splitView.isVertical = false
        splitView.autosaveName = NSSplitView.AutosaveName()
        splitView.identifier = NSUserInterfaceItemIdentifier(rawValue: splitViewRestorationIdentifier)
        
        mapController.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        logController.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
        let mapItem = NSSplitViewItem(viewController: mapController)
        addSplitViewItem(mapItem)
        
        let logItem = NSSplitViewItem(viewController: logController)
        addSplitViewItem(logItem)
        
        splitView.setPosition(view.bounds.height*2/3, ofDividerAt: 0)
        splitView.layoutSubtreeIfNeeded()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

