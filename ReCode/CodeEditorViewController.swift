//
//  CodeEditorViewController.swift
//  ReCode
//
//  Created by Дмитро  on 17.09.2022.
//

import Cocoa

class CodeEditorViewController: NSViewController {
    @IBOutlet  weak var textView: NSTextView!
    
    var codes: [String] = []
    
    lazy var syntaxHighlighter = SyntaxHighlighter(textView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textStorage?.delegate = self
    }
    
    @IBAction func pressedAdd(_ sender: NSButton) {
        let range = textView.selectedRange()
        
        print(range)
        
        let str = textView.string as NSString?   // So we cast String? to NSString?
        let substr = str?.substring(with: range)      // To be able to use the range in substring(with:)
        
        if let resultString = substr {
            print(resultString)
            codes.append(resultString)
        }
    }
    
    @IBAction func showResult(_ sender: NSButton) {
        syntaxHighlighter.colorize()
        print(textView.string.lastWord ?? "ok") // world!!!
    }
    
}


extension CodeEditorViewController: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        syntaxHighlighter.colorize()
        print("hello",editedRange)
        syntaxHighlighter.colorize(range: editedRange)
    }
}


extension String {

    func trim(_ emptyToNil: Bool = true)->String? {
        let text = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return emptyToNil && text.isEmpty ? nil : text
    }

    var lastWord: String? {
        if let size = self.lastIndex(of: " "), size >= self.startIndex {
            return String(self[size...]).trim()
        }
        return nil
    }

}
