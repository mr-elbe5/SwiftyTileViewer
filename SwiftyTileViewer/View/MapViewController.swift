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

class MapViewController: NSViewController {
    
    let scrollView = NSScrollView()
    let imageView = NSImageView()
    
    var mapData = [(zoom: Int, x: Int, y: Int)]()
    var unrenderedMapData = [(zoom: Int, x: Int, y: Int)]()
    var loading = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        scrollView.hasVerticalRuler = true
        scrollView.hasHorizontalRuler = false
        view = scrollView
        imageView.autoresizingMask = [.width, .height]
        imageView.isEditable = false
        scrollView.documentView = imageView
    }
    
    func loadMaps(data: [(zoom: Int, x: Int, y: Int)]){
        if loading{
            Log.warn("still loading tiles")
            return
        }
        mapData = data
        loading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadMapFromList()
        }
    }
    
    func stopLoading(){
        loading = false
    }
    
    func loadMapFromList(){
        if mapData.isEmpty{
            if !unrenderedMapData.isEmpty{
                mapData.append(contentsOf: unrenderedMapData)
                unrenderedMapData.removeAll()
                Log.info("retrying unrendered tiles")
            }
            else{
                Log.info("no more tiles to load")
                self.loading = false
                return
            }
        }
        if !loading{
            Log.info("loading interrupted")
            return
        }
        let data = mapData.removeFirst()
        let urlString = "\(Preferences.shared.urlPattern)\(data.zoom)/\(data.x)/\(data.y).png"
        if let url = URL(string: urlString){
            Log.info("requesting tile \(data.zoom)/\(data.x)/\(data.y)")
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(30*60))
            let task = URLSession.shared.dataTask(with: request) { fileData, response, error in
                if let error = error {
                    Log.error(error.localizedDescription)
                    self.loading = false
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else{
                    Log.error("error in response: \(response.debugDescription)")
                    return
                }
                if httpResponse.statusCode == 404{
                    Log.warn("tile not yet rendered")
                    self.unrenderedMapData.append(data)
                    self.loadMapFromList()
                    return
                }
                if !(200...299).contains(httpResponse.statusCode){
                    Log.error("error in response: \(response.debugDescription)")
                    self.loading = false
                    return
                }
                if let fileData = fileData, let image = NSImage(data: fileData){
                    DispatchQueue.main.async {
                        Log.info("tile loaded")
                        self.imageView.image = image
                    }
                    self.loadMapFromList()
                }
            }
            task.resume()
        }
    }
    
}

