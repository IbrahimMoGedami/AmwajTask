//
//  String+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import UIKit

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "Hello From String Extension")
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var int: Int? {
        return Int(self)
    }
    
    var double: Double? {
        return Double(self)
    }
    
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var addKm: String {
        return "\(self) \("Km")"
    }
    
    var addTime: String {
        return "\(self) \("Min")"
    }
    
    var trimmedString: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var replacedArabicDigitsWithEnglish: String {
        var string = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { string = string.replacingOccurrences(of: $0, with: $1) }
        return string
    }
    
    var withCommasRemoved: String {
        return replacingOccurrences(of: ",", with: "")
    }
}

struct NSMutableAttributedStringConfig {
    private(set) var text: String
    private(set) var font: UIFont
    private(set) var color: UIColor
    private(set) var alignment: NSTextAlignment
    
    init(text: String?, font: UIFont?, color: UIColor?, alignment: NSTextAlignment?) {
        self.text = text ?? ""
        self.font = font ?? UIFont()//.mainMedium(of: 12)
        self.color = color ?? .mainBlack
        self.alignment = alignment ?? .natural
    }
}

extension NSMutableAttributedString {
    
    convenience init(with config: [NSMutableAttributedStringConfig]) {
        // Btn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        guard !config.isEmpty else {
            self.init(string: "")
            return
        }
        
        let firstConfig = config.first!
        
        self.init(string: firstConfig.text,
                  attributes: [
                    .foregroundColor: firstConfig.color,
                    .font: firstConfig.font,
                    .paragraphStyle: NSMutableParagraphStyle(alignment: firstConfig.alignment)
                  ])
        
        let styles = config.dropFirst().map({
            NSAttributedString(string: $0.text, attributes: [
                .foregroundColor: $0.color,
                .font: $0.font,
                .paragraphStyle: NSMutableParagraphStyle(alignment: $0.alignment)
                ])
        })
        
        for style in styles {
            append(style)
        }
    }
}

extension NSMutableParagraphStyle {
     convenience init(alignment: NSTextAlignment) {
        self.init()
        self.alignment = alignment
    }
}
