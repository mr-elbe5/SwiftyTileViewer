/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

extension NSTextView {

    func append(string: String, scrollDown: Bool = true) {
        textStorage?.append(NSAttributedString(string: string))
        if scrollDown {
            scrollToEndOfDocument(nil)
        }
    }

    func appendText(_ string : String, color: NSColor? = nil, backgroundColor: NSColor? = nil, font: NSFont? = nil){
        var attributes = Dictionary<NSAttributedString.Key, Any>()
        if let color = color{
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        if let backgroundColor = backgroundColor{
            attributes[NSAttributedString.Key.backgroundColor] = backgroundColor
        }
        if let font = font{
            attributes[NSAttributedString.Key.font] = font
        }
        textStorage?.append(NSAttributedString(string: string, attributes: attributes))
    }

    func appendLine(_ string : String, color: NSColor? = nil, backgroundColor: NSColor? = nil, font: NSFont? = nil){
        appendText(string + "\n", color: color, backgroundColor: backgroundColor, font: font)
    }

}
