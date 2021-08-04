/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class MainViewController: NSSplitViewController {
    
    private let splitViewRestorationIdentifier = "de.elbe5.restorationId:mainViewController"
    
    lazy var controlController = ControlViewController()
    lazy var mapSplitController = MapSplitViewController()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        view.frame = CGRect(x: 0, y: 0, width: Statics.startSize.width, height: Statics.startSize.height)
        view.wantsLayer = true
        
        splitView.dividerStyle = .paneSplitter
        splitView.autosaveName = NSSplitView.AutosaveName()
        splitView.identifier = NSUserInterfaceItemIdentifier(rawValue: splitViewRestorationIdentifier)
        
        controlController.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        mapSplitController.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        
        let controlItem = NSSplitViewItem(viewController: controlController)
        addSplitViewItem(controlItem)
        
        let mapItem = NSSplitViewItem(viewController: mapSplitController)
        addSplitViewItem(mapItem)
        
        splitView.setPosition(view.bounds.width/3, ofDividerAt: 0)
        splitView.layoutSubtreeIfNeeded()
        
        controlController.mapController = mapSplitController.mapController
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


