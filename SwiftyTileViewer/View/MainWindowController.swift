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

class MainWindowController: NSWindowController, NSWindowDelegate {

    convenience init() {
        self.init(windowNibName: "")
    }

    override func loadWindow() {
        let window = MainWindow()
        window.title = Statics.title
        window.delegate = self
        contentViewController = MainViewController()
        self.window = window
    }

    // Window delegate

    func windowDidBecomeKey(_ notification: Notification) {
        window?.makeFirstResponder(nil)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }

}

