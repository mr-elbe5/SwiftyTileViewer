/*
 OSM Map Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa
import SwiftyLog
import SwiftyMacViewExtensions

class ControlViewController: NSViewController, PreferencesDelegate {
    
    var mapController : MapViewController? = nil
    
    var serverLabel = NSTextField(labelWithString: Preferences.shared.urlPattern + "xxxxxx xxxxxx xxxxx")

    var zoomLabel = NSTextField(labelWithString: "")
    var zoomSlider : NSSlider!
    
    var minLongitudeField = NSTextField(string: String(Preferences.shared.minLongitude))
    var maxLongitudeField = NSTextField(string: String(Preferences.shared.maxLongitude))
    var minLatitudeField = NSTextField(string: String(Preferences.shared.minLatitude))
    var maxLatitudeField = NSTextField(string: String(Preferences.shared.maxLatitude))
    
    var minXTileLabel = NSTextField(labelWithString: "0")
    var maxXTileLabel = NSTextField(labelWithString: "0")
    var maxYTileLabel = NSTextField(labelWithString: "0")
    var minYTileLabel = NSTextField(labelWithString: "0")
    var computeTilesButton : NSButton!
    
    var singleXField = NSTextField(string: "0")
    var singleYField = NSTextField(string: "0")
    var showSingleTileButton : NSButton!
    
    var minXTileField = NSTextField(string: String("0"))
    var maxXTileField = NSTextField(string: String("0"))
    var minYTileField = NSTextField(string: String("0"))
    var maxYTileField = NSTextField(string: String("0"))
    var showAllTilesButton : NSButton!
    var retryFailedTilesButton : NSButton!
    var stopButton : NSButton!
    
    var zoom : Int = 0

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
        let font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        
        let serverBox = NSBox()
        guard let svView = serverBox.contentView else { return }
        serverBox.title = "Map Server"
        serverBox.titleFont = font
        view.addSubview(serverBox)
        serverBox.placeBelow(anchor: view.topAnchor)
        serverLabel.lineBreakMode = .byCharWrapping
        svView.addSubview(serverLabel)
        serverLabel.placeBelow(anchor: svView.topAnchor)
        serverLabel.connectBottom(view: svView)
        
        let coordinateBox = NSBox()
        guard let cbView = coordinateBox.contentView else { return }
        coordinateBox.title = "Bounding Coordinates"
        coordinateBox.titleFont = font
        view.addSubview(coordinateBox)
        coordinateBox.placeBelow(view: serverBox)
        cbView.addSubview(maxLatitudeField)
        maxLatitudeField.setAnchors()
        maxLatitudeField.top(cbView.topAnchor,inset: 10)
        maxLatitudeField.centerX(cbView.centerXAnchor)
        maxLatitudeField.width(50)
        cbView.addSubview(minLongitudeField)
        minLongitudeField.setAnchors()
        minLongitudeField.top(maxLatitudeField.bottomAnchor)
        minLongitudeField.leading(cbView.leadingAnchor)
        minLongitudeField.width(50)
        cbView.addSubview(maxLongitudeField)
        maxLongitudeField.setAnchors()
        maxLongitudeField.top(maxLatitudeField.bottomAnchor)
        maxLongitudeField.trailing(cbView.trailingAnchor)
        maxLongitudeField.width(50)
        cbView.addSubview(minLatitudeField)
        minLatitudeField.setAnchors()
        minLatitudeField.top(minLongitudeField.bottomAnchor)
        minLatitudeField.centerX(cbView.centerXAnchor)
        minLatitudeField.width(50)
        minLatitudeField.bottom(cbView.bottomAnchor,inset: 5)
        
        let zoomBox = NSBox()
        guard let zbView = zoomBox.contentView else { return }
        zoomBox.title = "Zoom level"
        zoomBox.titleFont = font
        view.addSubview(zoomBox)
        zoomBox.placeBelow(view: coordinateBox)
        zoomSlider = NSSlider(value: 0, minValue: 0, maxValue: 18, target: self, action: #selector(zoomChanged))
        zoomSlider.numberOfTickMarks = 19
        zoomSlider.altIncrementValue = 1
        zoomSlider.allowsTickMarkValuesOnly = true
        zoomSlider.tickMarkPosition = .below
        zbView.addSubview(zoomSlider)
        zoomSlider.placeBelow(anchor: zbView.topAnchor)
        updateZoomLabel()
        zbView.addSubview(zoomLabel)
        zoomLabel.placeBelow(view: zoomSlider)
        zoomLabel.connectBottom(view: zbView)
        
        let tilesBox = NSBox()
        guard let tbView = tilesBox.contentView else { return }
        tilesBox.title = "Tile limits"
        tilesBox.titleFont = font
        view.addSubview(tilesBox)
        tilesBox.placeBelow(view: zoomBox)
        maxYTileLabel.alignment = .center
        tbView.addSubview(maxYTileLabel)
        maxYTileLabel.setAnchors()
        maxYTileLabel.top(tbView.topAnchor, inset: 10)
        maxYTileLabel.centerX(tbView.centerXAnchor)
        maxYTileLabel.width(50)
        minXTileLabel.alignment = .center
        tbView.addSubview(minXTileLabel)
        minXTileLabel.setAnchors()
        minXTileLabel.top(maxYTileLabel.bottomAnchor)
        minXTileLabel.leading(tbView.leadingAnchor)
        minXTileLabel.width(50)
        maxXTileLabel.alignment = .center
        tbView.addSubview(maxXTileLabel)
        maxXTileLabel.setAnchors()
        maxXTileLabel.top(maxYTileLabel.bottomAnchor)
        maxXTileLabel.trailing(tbView.trailingAnchor)
        maxXTileLabel.width(50)
        minYTileLabel.alignment = .center
        tbView.addSubview(minYTileLabel)
        minYTileLabel.setAnchors()
        minYTileLabel.top(minXTileLabel.bottomAnchor)
        minYTileLabel.centerX(tbView.centerXAnchor)
        minYTileLabel.width(50)
        computeTilesButton = NSButton(title: "Compute", target: self, action: #selector(computeTileBounds))
        tbView.addSubview(computeTilesButton)
        computeTilesButton.placeBelow(view: minYTileLabel)
        computeTilesButton.bottom(tbView.bottomAnchor, inset: 5)
        computeTileBounds()
        
        let singleTileBox = NSBox()
        guard let sbView = singleTileBox.contentView else { return }
        singleTileBox.title = "Show single tile"
        singleTileBox.titleFont = font
        view.addSubview(singleTileBox)
        singleTileBox.placeBelow(view: tilesBox)
        let xLabel = NSTextField(labelWithString: "x:")
        sbView.addSubview(xLabel)
        xLabel.setAnchors()
        xLabel.top(sbView.topAnchor, inset: 10)
        xLabel.leading(sbView.leadingAnchor, inset: 10)
        sbView.addSubview(singleXField)
        singleXField.setAnchors()
        singleXField.top(sbView.topAnchor, inset: 10)
        singleXField.leading(sbView.centerXAnchor)
        singleXField.trailing(sbView.trailingAnchor, inset: 10)
        let yLabel = NSTextField(labelWithString: "y:")
        sbView.addSubview(yLabel)
        yLabel.setAnchors()
        yLabel.top(singleXField.bottomAnchor)
        yLabel.leading(sbView.leadingAnchor, inset: 10)
        sbView.addSubview(singleYField)
        singleYField.setAnchors()
        singleYField.top(singleXField.bottomAnchor)
        singleYField.leading(sbView.centerXAnchor)
        singleYField.trailing(sbView.trailingAnchor, inset: 10)
        showSingleTileButton = NSButton(title: "Show", target: self, action: #selector(showSingleTile))
        sbView.addSubview(showSingleTileButton)
        showSingleTileButton.placeBelow(view: singleYField)
        showSingleTileButton.bottom(sbView.bottomAnchor, inset: 5)
        
        let allTilesBox = NSBox()
        guard let abView = allTilesBox.contentView else { return }
        allTilesBox.title = "Show all tiles of zoom level"
        allTilesBox.titleFont = font
        view.addSubview(allTilesBox)
        allTilesBox.placeBelow(view: singleTileBox)
        let warning = NSTextField(labelWithAttributedString: NSAttributedString(string: "See help information!", attributes: [NSAttributedString.Key.foregroundColor : NSColor.red]))
        abView.addSubview(warning)
        warning.setAnchors()
        warning.top(abView.topAnchor, inset: 5)
        warning.centerX(abView.centerXAnchor)
        abView.addSubview(minYTileField)
        minYTileField.setAnchors()
        minYTileField.top(warning.bottomAnchor, inset: 5)
        minYTileField.centerX(abView.centerXAnchor)
        minYTileField.width(50)
        abView.addSubview(minXTileField)
        minXTileField.setAnchors()
        minXTileField.top(minYTileField.bottomAnchor)
        minXTileField.leading(abView.leadingAnchor, inset: 10)
        minXTileField.width(50)
        abView.addSubview(maxXTileField)
        maxXTileField.setAnchors()
        maxXTileField.top(minYTileField.bottomAnchor)
        maxXTileField.trailing(cbView.trailingAnchor, inset: 10)
        maxXTileField.width(50)
        abView.addSubview(maxYTileField)
        maxYTileField.setAnchors()
        maxYTileField.top(maxXTileField.bottomAnchor)
        maxYTileField.centerX(abView.centerXAnchor)
        maxYTileField.width(50)
        showAllTilesButton = NSButton(title: "Show as sequence", target: self, action: #selector(loadCompleteLevel))
        abView.addSubview(showAllTilesButton)
        showAllTilesButton.placeBelow(view: maxYTileField)
        retryFailedTilesButton = NSButton(title: "Retry failed tiles", target: self, action: #selector(retryFailed))
        abView.addSubview(retryFailedTilesButton)
        retryFailedTilesButton.placeBelow(view: showAllTilesButton)
        stopButton = NSButton(title: "Stop", target: self, action: #selector(stopLoading))
        abView.addSubview(stopButton)
        stopButton.placeBelow(view: retryFailedTilesButton)
        stopButton.bottom(abView.bottomAnchor,inset: 5)
        Preferences.shared.delegate = self
    }
    
    func preferencesChanged(){
        serverLabel.stringValue = Preferences.shared.urlPattern
        minLongitudeField.stringValue = String(Preferences.shared.minLongitude)
        maxLongitudeField.stringValue = String(Preferences.shared.maxLongitude)
        minLatitudeField.stringValue = String(Preferences.shared.minLatitude)
        maxLatitudeField.stringValue = String(Preferences.shared.maxLatitude)
    }
    
    func updateZoomLabel(){
        zoomLabel.stringValue = "\(zoom)"
    }
    
    @objc func computeTileBounds(){
        let maxLatitude = min(maxLatitudeField.doubleValue, 85)
        let minLongitude = max(minLongitudeField.doubleValue, -180)
        let maxLongitude = min(maxLongitudeField.doubleValue, 179.999)
        let minLatitude = max(minLatitudeField.doubleValue, -85.0)
        maxYTileLabel.stringValue = String(Int(floor((1 - log( tan( maxLatitude * Double.pi / 180.0 ) + 1 / cos( maxLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom)))))
        minXTileLabel.stringValue = String(Int(floor((minLongitude + 180) / 360.0 * pow(2.0, Double(zoom)))))
        maxXTileLabel.stringValue = String(Int(floor((maxLongitude + 180) / 360.0 * pow(2.0, Double(zoom)))))
        minYTileLabel.stringValue = String(Int(floor((1 - log(tan( minLatitude * Double.pi / 180.0 ) + 1 / cos( minLatitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom)))))
    }
    
    @objc func zoomChanged(){
        let newZoom = Int(zoomSlider.intValue)
        if newZoom != zoom{
            zoom = newZoom
            updateZoomLabel()
            computeTileBounds()
        }
    }
    
    @objc func showSingleTile() {
        if !checkServerURL(){
            return
        }
        let x = Int(singleXField.intValue)
        let y = Int(singleYField.intValue)
        var mapData = [(zoom: Int, x: Int, y: Int)]()
        mapData.append((zoom: zoom, x: x, y: y))
        mapController?.loadMaps(data: mapData)
    }
    
    @objc func loadCompleteLevel(){
        if !checkServerURL(){
            return
        }
        let xMin = Int(minXTileField.intValue)
        let xMax = Int(maxXTileField.intValue)
        let yMin = Int(minYTileField.intValue)
        let yMax = Int(maxYTileField.intValue)
        if xMin > xMax{
            return
        }
        if yMin > yMax{
            return
        }
        var mapData = [(zoom: Int, x: Int, y: Int)]()
        for x in xMin...xMax{
            for y in yMin...yMax{
                mapData.append((zoom: zoom, x: x, y: y))
            }
        }
        mapController?.loadMaps(data: mapData)
    }
    
    func checkServerURL() -> Bool{
        if Preferences.shared.urlPattern.isEmpty{
            let alert = NSAlert()
            alert.messageText = "No server configured"
            alert.informativeText = "Please set a server URL in Preferences."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: view.window!, completionHandler: nil)
            return false
        }
        return true
    }
    
    @objc func retryFailed(){
        if !checkServerURL(){
            return
        }
        mapController?.loadFailedTiles()
    }
    
    @objc func stopLoading(){
        mapController?.stopLoading()
    }

}

