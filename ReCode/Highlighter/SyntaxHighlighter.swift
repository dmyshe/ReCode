//
//  SyntaxHighlighter.swift
//  ReCode
//
//  Created by Дмитро  on 17.09.2022.
//

import Cocoa
import Foundation

class SyntaxHighlighter {
    var textView : NSTextView
    
    struct color {
        static let normal     = [NSAttributedString.Key.foregroundColor: NSColor.black]
        static let comment    = [NSAttributedString.Key.foregroundColor: NSColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.0)] // green
        static let keyword    = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6771982908, green: 0.238362819, blue: 0.6413504481, alpha: 1)]
        static let identifier = [NSAttributedString.Key.foregroundColor: NSColor(red: 0.33, green: 0.20, blue: 0.66, alpha: 1.0)] // purple
        static let symbol     = [NSAttributedString.Key.foregroundColor: NSColor(red: 0.75, green: 0.50, blue: 0.00, alpha: 1.0)] // orange
        static let type       = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2941176471, green: 0.1098039216, blue: 0.6901960784, alpha: 1), NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)]
        static let literal    = [NSAttributedString.Key.foregroundColor: NSColor(red: 0.66, green: 0.00, blue: 0.00, alpha: 1.0)] // red
        static let number     = [NSAttributedString.Key.foregroundColor: NSColor(red: 0.00, green: 0.00, blue: 0.75, alpha: 1.0)] // blue
        static let attribute  = [NSAttributedString.Key.foregroundColor: NSColor(red: 1.00, green: 0.33, blue: 0.00, alpha: 1.0)] // orange
        static let uikitType  = [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.2941176471, green: 0.1098039216, blue: 0.6901960784, alpha: 1)]
    }
    
    struct regex {
        static let keywords      = "\\b(class|deinit|enum|extension|func|import|init|let|protocol|static|struct|subscript|typealias|var|throws|@|IBAction|rethrows|break|case|continue|default|do|else|fallthrough|if|in|for|return|switch|where|while|repeat|catch|guard|defer|try|throw|as|dynamicType|is|new|super|self|Self|Type|associativity|didSet|get|infix|inout|left|mutating|none|nonmutating|operator|override|postfix|precedence|prefix|right|set|unowned((un)?safe)?|weak|willSet|switch|case|default|where|if|else|continue|break|fallthrough|return|while|repeat|for|in|catch|do|operator|prefix|infix|postfix|open|public|internal|fileprivate|private|convenience|dynamic|final|lazy|(non)?mutating|optional|override|required|static|unowned((un)?safe)?|weak|true|false|nil)\\b"
        static let types         = "\\b(Int|Float|Double|String|Bool|Character|Void|U?Int(8|16|32|64)?|Array|Dictionary|(Array)(<.*>)|(Dictionary)(<.*>)|(Optional)(<.*>)|(protocol)(<.*>))\\b"
        static let uikitTypes    = "\\b(NSButton)"
        static let stringLiteral = "(\".*\")"
        static let numberLiteral = "\\b([0-9]*(\\.[0-9]*)?)\\b"
        static let symbols       = "(\\+|-|\\*|/|=|\\{|\\}|\\[|\\]|\\(|\\))"
        static let identifiers   = "(\\B\\$[0-9]+|\\b[\\w^\\d][\\w\\d]*\\b|\\B`[\\w^\\d][\\w\\d]*`\\B)"
        static let attributes    = "((@)(\\B\\$[0-9]+|\\b[\\w^\\d][\\w\\d]*\\b|\\B`[\\w^\\d][\\w\\d]*`\\B))(\\()(.*)\\)"
        static let commentLine   = "(//.*)"
        static let commentBlock  = "(/\\*.*\\*/)" // Not working, regex must search block not line
    }
    
    let patterns = [
        regex.commentLine   : color.comment,
        regex.commentBlock  : color.comment,
        regex.stringLiteral : color.literal,
        regex.numberLiteral : color.number,
        regex.keywords      : color.keyword,
        regex.types         : color.type,
        regex.uikitTypes    : color.uikitType
        /*regex.attributes    : color.attribute*/
        /*regex.identifiers   : color.identifier*/
    ]
    
    init(_ textView: NSTextView) {
        self.textView = textView
    }
    
    // Colorize all
    func colorize() {
        let all = textView.string
        if all.isEmpty {
            return
        }
        let range = NSString(string: textView.string).range(of: all)
        colorize(range: range)
    }
    
    // Colorize range
    func colorize( range: NSRange) {
            var extended = NSUnionRange(range, NSString(string: textView.string).lineRange(for: NSMakeRange(range.location, 0)))
            extended = NSUnionRange(range, NSString(string: textView.string).lineRange(for: NSMakeRange(NSMaxRange(range), 0)))
        
            for (pattern, attribute) in patterns {
                applyStyles(textView, range: extended, pattern: pattern, attribute: attribute)
            }
        }
        
        func applyStyles(_ textView: NSTextView, range: NSRange, pattern: String, attribute: [NSAttributedString.Key: Any]) {
            let regex = try? NSRegularExpression(pattern: pattern, options: [NSRegularExpression.Options.anchorsMatchLines])
            regex?.enumerateMatches(in: textView.string, options: [], range: range) {
                match, flags, stop in
                
                let matchRange = match?.range(at: 1)
                textView.textStorage?.addAttributes(attribute, range: matchRange!)
            }
        }
}
