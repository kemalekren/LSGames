//
//  String.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import UIKit
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        var attribStr = NSMutableAttributedString()
        
        do {
            
            attribStr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue,], documentAttributes: nil)
            
            let modified = usingRegularExpression(str: attribStr)
            let textRangeForFont : NSRange = NSMakeRange(0, modified.length)
            
            modified.addAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 17)!], range: textRangeForFont)
            
            return modified
            
        } catch {
            return NSAttributedString()
        }
    }
    
    
    private func usingRegularExpression(str: NSMutableAttributedString)-> NSMutableAttributedString {
        
        let pattern = "(<img.*?src=\")(.*?)(\".*?>)"
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            
        }
        let modifiedString = regex?.stringByReplacingMatches(in: str.string, options: [], range: NSRange(location: 0, length: str.length), withTemplate: "") ?? ""
        let result = NSMutableAttributedString(string: modifiedString)
        
        return result
    }
    
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
