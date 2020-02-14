//
//  Ext_String.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2016 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if os(OSX)
    import AppKit
#else
    import Foundation
    import UIKit
#endif


/// This extesion adds some useful functions to String
public extension String {

    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }

    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }

    /// EZSE: Init string with a base64 encoded string
    init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }

    /// EZSE: base64 encoded of string
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }

    // MARK: - Variables -

    /// Return the float value
    public var floatValue: Float {
        return (self as NSString).floatValue
    }

    // MARK: - Instance functions -

    /**
     Returns the lenght of the string

     - returns: Returns the lenght of the string
     */
    public var length: Int {
        return self.characters.count
    }

    /**
     Get the character at a given integer of Index
     - parameter index: The index of Int
     - returns: Returns the character at a given index
     */
    public func characterAtIndex(_ iIndex: Int) -> Character {
        return self[iIndex]
    }

    // MARK: Subscript functions

    /**
     Returns the character at the given index
     - parameter index: The index
     - returns: Returns the character at the given index
     */
    /// Get the character at a given integer of Index
    /// string.characters.index == string.index
    public subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }

    // EZSE: Cut string from closedrange
    public subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }

    /**
     It's like substringFromIndex(index: String.Index), but it requires an Int as index
     - parameter index: The index
     - returns: Returns the substring from index
     */
    public func substringFromIndex(_ iIndex: Int) -> String {
        return self.substring(from: index(startIndex, offsetBy: iIndex))
    }

    /**
     It's like substringToIndex(index: String.Index), but it requires an Int as index
     - parameter index: The index
     - returns: Returns the substring to index
     */
    public func substringToIndex(_ index: Int) -> String {
        return self.substring(to: characters.index(startIndex, offsetBy: index))
        //self.substringToIndex(self.startIndex.advancedBy(index))
    }

    ///
    public func splitByCharacter(_ character: Character) -> (String, String)? {
        guard let cIndex = self.characters.index(of: character) else {return nil}
        let index = self.index(after: cIndex)
        let key = substring(to: index), value = substring(from: index)
        return (key, value)
    }

    /**
     Creates a substring with a given range
     - parameter range: The range
     - returns: Returns the string between the range
     */
    public func substringWithRange(range: Range<Int>) -> String {
        return self[range]
    }

    /**
     Returns the string from a given range
     Example: print("BFKit"[1...3]) the result is "FKi"
     - parameter range: The range
     - returns: Returns the string from a given range
     */
    public subscript(integerRange: Range<Int>) -> String { //等同于 public subscript(range: Range<Int>)
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }

    /**
     Creates a substring from the given character
     - parameter character: The character
     - returns: Returns the substring from character
     */
    public func substringFromCharacter(character: Character) -> String? {
        if let index: Int = self.getIndexOf(character) {
            return substringFromIndex(index)
        }
        return nil
    }

    /**
     Creates a substring to the given character
     - parameter character: The character
     - returns: Returns the substring to character
     */
    public func substringToCharacter(character: Character) -> String? {
        if let index = getIndexOf(character) {
            return substringToIndex(index)
        }
        return nil
    }

    /**
     Returns the index of the given character
     - parameter char: The character to search
     - returns: Returns the index of the given character, -1 if not found
     */
    public func indexOfCharacter(_ character: Character) -> Int {
        guard let i = getIndexOf(character) else { return -1 }
        return i
    }

    ///EZSE: Returns the first index of the occurency of the character in String
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in characters.enumerated() {
            if c == char {
                return index
            }
        }
        return nil
    }

    /**
     Search in a given string a substring from the start char to the end char (excluded form final string).
     Example: "This is a test" with start char 'h' and end char 't' will return "is is a "

     - parameter charStart: The start char
     - parameter charEnd:   The end char

     - returns: Returns the substring
     */
    public func searchCharStart(charStart: Character, charEnd: Character) -> String {
        return String.searchInString(string: self, charStart: charStart, charEnd: charEnd)
    }

    /**
     Check if self has the given substring in case-sensitive

     - parameter string:        The substring to be searched
     - parameter caseSensitive: If the search has to be case-sensitive or not

     - returns: Returns true if founded, false if not
     */
    public func hasString(string: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.range(of: string) != nil
        } else {
            return self.lowercased().range(of: string.lowercased()) != nil
        }
    }


    /**
     Encode the given string to Base64

     - returns: Returns the encoded string
     */
    public func encodeToBase64() -> String {
        return String.encodeToBase64(self)
    }

    /**
     Decode the given Base64 to string

     - returns: Returns the decoded string
     */
    public func decodeBase64() -> String {
        return String.decodeBase64(self)
    }

    /**
     Convert self to a NSData

     - returns: Returns self as NSData
     */
    public func convertToNSData() -> NSData {
        return NSString.convertToNSData(self as NSString)
    }

    /**
     Conver self to a capitalized string.
     Example: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test"
     - returns: Returns the capitalized sentence string
     */
    public func sentenceCapitalizedString() -> String {
        if self.length == 0 {
            return ""
        }
        let uppercase: String = self.substringToIndex(1).uppercased()
        let lowercase: String = self.substringFromIndex(1).lowercased()
        return uppercase.appending(lowercase)
    }

    /**
     Returns a human legible string from a timestamp

     - returns: Returns a human legible string from a timestamp
     */
    public func dateFromTimestamp() -> String {
        let year: String = self.substringToIndex(4)
        var month: String = self.substringFromIndex(5)
        month = month.substringToIndex(4)
        var day: String = self.substringFromIndex(8)
        day = day.substringToIndex(2)
        var hours: String = self.substringFromIndex(11)
        hours = hours.substringToIndex(2)
        var minutes: String = self.substringFromIndex(14)
        minutes = minutes.substringToIndex(2)

        return "\(day)/\(month)/\(year) \(hours):\(minutes)"
    }

    /**
     Returns a new string containing matching regular expressions replaced with the template string

     - parameter regexString: The regex string
     - parameter replacement: The replacement string

     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    public func stringByReplacingWithRegex(regexString: String, withString replacement: String) throws -> String {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, self.length), withTemplate: "")
    }

    /**
     Encode self to an encoded url string
     URL encode a string (percent encoding special chars)
     - returns: Returns the encoded NSString
     */
    public func URLEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    // EZSE: URL encode a string (percent encoding special chars) mutating version
    mutating func URLEncode() {
        self = URLEncode()
    }

    // EZSE: Removes percent encoding from string
    public func URLDecoded() -> String {
        return removingPercentEncoding ?? self
    }

    // EZSE : Mutating versin of urlDecoded
    mutating func URLDecoded() {
        self = URLDecoded()
    }

    /// Returns the last path component
    public var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }

    /// Returns the path extension
    public var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }

    /// Delete the last path component
    public var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }

    /// Delete the path extension
    public var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }

    /// Returns an array of path components
    public var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }

    /**
     Appends a path component to the string

     - parameter path: Path component to append

     - returns: Returns all the string
     */
    public func stringByAppendingPathComponent(path: String) -> String {
        let string = self as NSString

        return string.appendingPathComponent(path)
    }

    /**
     Appends a path extension to the string

     - parameter ext: Extension to append

     - returns: returns all the string
     */
    public func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString

        return nsSt.appendingPathExtension(ext)
    }

    /// Converts self to a NSString
    public var NS: NSString {
        return (self as NSString)
    }

    /**
     Returns if self is a valid UUID or not

     - returns: Returns if self is a valid UUID or not
     */
    public func isUUID() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }
    
    /// Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    ///
    /// - Returns: Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    func readableUUID() -> String {
        trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }

    /**
     Returns if self is a valid UUID for APNS (Apple Push Notification System) or not

     - returns: Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     */
    public func isUUIDForAPNS() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{32}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.length))
            return matches == 1
        } catch {
            return false
        }
    }

    /**
     Converts self to an UUID APNS valid (No "<>" or "-" or spaces)
     - returns: Converts self to an UUID APNS valid (No "<>" or "-" or spaces)
     */
    public func convertToAPNSUUID() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }

    /**
     Used to calculate text height for max width and font

     - parameter width: Max width to fit text
     - parameter font:  Font used in text

     - returns: Returns the calculated height of string within width using given font
     */
    public func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        var size = CGSize.zero
        if self.length > 0 {
            let frame: CGRect = self.boundingRect(with: CGSize(width: width, height: 999999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
            size = CGSize(width:frame.size.width, height:frame.size.height + 1)
        }
        return size.height
    }



    /**
     Returns the index of the given character, -1 if not found

     - parameter character: The character to found

     - returns: Returns the index of the given character, -1 if not found
     */
    public subscript(character: Character) -> Int {
        return self.indexOfCharacter(character)
    }

    /**
     Returns the character at the given index as String

     - parameter index: The index

     - returns: Returns the character at the given index as String
     */
    public subscript(index: Int) -> String {
        return String(self[index] as Character)
    }


    // MARK: - Class functions -

    /**
     Search in a given string a substring from the start char to the end char (excluded form final string).
     Example: "This is a test" with start char 'h' and end char 't' will return "is is a "

     - parameter string:    The string to search in
     - parameter charStart: The start char
     - parameter charEnd:   The end char

     - returns: Returns the substring
     */
    public static func searchInString(string: String, charStart: Character, charEnd: Character) -> String {
        var start = 0, stop = 0
        for var i in 0 ..< string.length {
            if string.characterAtIndex(i) == charStart {
                start = i+1
                i += 1
            }
            if string.characterAtIndex(i) == charEnd {
                stop = i
                break
            }
        }
        stop -= start
        return string.substringFromIndex(start).substringToIndex(stop)
    }

    /**
     Check if self is an email
     - returns: Returns true if it's an email, false if not
     */
    public func isEmail() -> Bool {
        return String.isEmail(email: self)//isEmail(email: self)//.isEmail(self)
    }

    /// EZSE: Checks if String contains Email
    public var hasEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    /**
     Check if the given string is an email
     - parameter email: The string to be checked
     - returns: Returns true if it's an email, false if not
     */
    public static func isEmail(email: String) -> Bool {
        let emailRegEx: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let regExPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return regExPredicate.evaluate(with: email.lowercased())
    }

    /**
     Convert a string to UTF8

     - parameter string: String to be converted

     - returns: Returns the converted string
     */
    public static func convertToUTF8Entities(string: String) -> String {
        return string.replacingOccurrences(of: "%27", with: "'")
            .replacingOccurrences(of:"%e2%80%99".capitalized, with: "’")
            .replacingOccurrences(of:"%2d".capitalized, with: "-")
            .replacingOccurrences(of:"%c2%ab".capitalized, with: "«")
            .replacingOccurrences(of:"%c2%bb".capitalized, with: "»")
            .replacingOccurrences(of:"%c3%80".capitalized, with: "À")
            .replacingOccurrences(of:"%c3%82".capitalized, with: "Â")
            .replacingOccurrences(of:"%c3%84".capitalized, with: "Ä")
            .replacingOccurrences(of:"%c3%86".capitalized, with: "Æ")
            .replacingOccurrences(of:"%c3%87".capitalized, with: "Ç")
            .replacingOccurrences(of:"%c3%88".capitalized, with: "È")
            .replacingOccurrences(of:"%c3%89".capitalized, with: "É")
            .replacingOccurrences(of:"%c3%8a".capitalized, with: "Ê")
            .replacingOccurrences(of:"%c3%8b".capitalized, with: "Ë")
            .replacingOccurrences(of:"%c3%8f".capitalized, with: "Ï")
            .replacingOccurrences(of:"%c3%91".capitalized, with: "Ñ")
            .replacingOccurrences(of:"%c3%94".capitalized, with: "Ô")
            .replacingOccurrences(of:"%c3%96".capitalized, with: "Ö")
            .replacingOccurrences(of:"%c3%9b".capitalized, with: "Û")
            .replacingOccurrences(of:"%c3%9c".capitalized, with: "Ü")
            .replacingOccurrences(of:"%c3%a0".capitalized, with: "à")
            .replacingOccurrences(of:"%c3%a2".capitalized, with: "â")
            .replacingOccurrences(of:"%c3%a4".capitalized, with: "ä")
            .replacingOccurrences(of:"%c3%a6".capitalized, with: "æ")
            .replacingOccurrences(of:"%c3%a7".capitalized, with: "ç")
            .replacingOccurrences(of:"%c3%a8".capitalized, with: "è")
            .replacingOccurrences(of:"%c3%a9".capitalized, with: "é")
            .replacingOccurrences(of:"%c3%af".capitalized, with: "ï")
            .replacingOccurrences(of:"%c3%b4".capitalized, with: "ô")
            .replacingOccurrences(of:"%c3%b6".capitalized, with: "ö")
            .replacingOccurrences(of:"%c3%bb".capitalized, with: "û")
            .replacingOccurrences(of:"%c3%bc".capitalized, with: "ü")
            .replacingOccurrences(of:"%c3%bf".capitalized, with: "ÿ")
            .replacingOccurrences(of:"%20", with: " ")
    }

    /**
     Encode the given string to Base64
     - parameter string: String to encode
     - returns: Returns the encoded string
     */
    public static func encodeToBase64(_ string: String) -> String {
        let data = string.data(using: .utf8) //.dataUsingEncoding(NSUTF8StringEncoding)!
        return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }

    /**
     Decode the given Base64 to string

     - parameter string: String to decode

     - returns: Returns the decoded string
     */
    public static func decodeBase64(_ string: String) -> String {
        let data: NSData = NSData(base64Encoded: string as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }

    /**
     Remove double or more duplicated spaces

     - returns: String without additional spaces
     */
    public func removeExtraSpaces() -> String {
        return self.NS.removeExtraSpaces() as String
    }

    /**
     Returns a new string containing matching regular expressions replaced with the template string

     - parameter regexString: The regex string
     - parameter replacement: The replacement string

     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    public func stringByReplacingWithRegex(regexString: String, replacement: String) -> String? {
        return try? self.stringByReplacingWithRegex(regexString: regexString, withString: replacement)
    }

    /**
     Convert HEX string (separated by space) to "usual" characters string.
     Example: "68 65 6c 6c 6f" -> "hello"
     - returns: Readable string
     */
    public func HEXToString() -> String {
        return self.NS.HEXToString() as String
    }

    /**
     Convert string to HEX string
     Example: "hello" -> "68656c6c6f"

     - returns: HEX string
     */
    public func stringToHEX() -> String {
        return self.NS.stringToHEX() as String
    }

    /**
     Used to create an UUID as String

     - returns: Returns the created UUID string
     */
    public static func generateUUID() -> String {
        let theUUID: CFUUID? = CFUUIDCreate(kCFAllocatorDefault)
        let string: CFString? = CFUUIDCreateString(kCFAllocatorDefault, theUUID)
        return string! as String
    }

    #if os(iOS)

    /// EZSE: copy string to pasteboard
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }

    #endif

    /// EZSE: Returns if String is a number
    public func isNumber() -> Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }

    /// EZSE: Extracts URLS from String
    public var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }

        let text = self

        if let detector = detector {
            detector.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count), using: {
                (result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }

        return urls
    }

    /// EZSE: Checking if String contains input with comparing options
    public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }

    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }

    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }

    //    ///EZSE: Returns the first index of the occurency of the character in String
    //    public func getIndexOf(_ char: Character) -> Int? {
    //        for (index, c) in characters.enumerated() {
    //            if c == char {
    //                return index
    //            }
    //        }
    //        return nil
    //    }

    /// EZSE: Converts String to NSString
    public var toNSString: NSString { return self as NSString }

    #if os(iOS)

    ///EZSE: Returns bold NSAttributedString
    public func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        return boldString
    }

    #endif

    ///EZSE: Returns underlined NSAttributedString
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        return underlineString
    }

    #if os(iOS)

    ///EZSE: Returns italic NSAttributedString
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }

    #endif

    #if os(iOS)

    ///EZSE: Returns hight of rendered string
    func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [String: AnyObject] = [NSAttributedString.Key.font.rawValue: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle.rawValue)
        }
        let size = CGSize(width: width, height: CGFloat(DBL_MAX))
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attrib, context: nil).height)
    }

    #endif

    ///EZSE: Returns NSAttributedString
    public func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        return colorString
    }

    ///EZSE: Returns NSAttributedString
    public func colorSubString(_ subString: String, color: UIColor) -> NSMutableAttributedString {
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString, options: NSString.CompareOptions.literal, range: NSRange(location: start, length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return attrText
    }

    /// EZSE: Checks if String contains Emoji
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }

    /// EZSE: Counts number of instances of the input inside String
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }

    /// EZSE: Capitalizes first character of String
    public mutating func capitalizeFirst() {
        guard characters.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }

    /// EZSE: Capitalizes first character of String, returns a new string
    public func capitalizedFirst() -> String {
        guard characters.count > 0 else { return self }
        var result = self

        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }

    /// EZSE: Uppercases first 'count' characters of String
    public mutating func uppercasePrefix(_ count: Int) {
        guard characters.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
    }

    /// EZSE: Uppercases first 'count' characters of String, returns a new string
    public func uppercasedPrefix(_ count: Int) -> String {
        guard characters.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
        return result
    }

    /// EZSE: Uppercases last 'count' characters of String
    public mutating func uppercaseSuffix(_ count: Int) {
        guard characters.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
    }

    /// EZSE: Uppercases last 'count' characters of String, returns a new string
    public func uppercasedSuffix(_ count: Int) -> String {
        guard characters.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(characters.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[characters.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
        return result
    }

    /// EZSE: Uppercases string in range 'range' (from range.startIndex to range.endIndex)
    public mutating func uppercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard characters.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
    }

    /// EZSE: Uppercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    public func uppercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard characters.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(characters.index(startIndex, offsetBy: from)..<characters.index(startIndex, offsetBy: to),
                               with: String(self[characters.index(startIndex, offsetBy: from)..<characters.index(startIndex, offsetBy: to)]).uppercased())
        return result
    }

    /// EZSE: Lowercases first character of String
    public mutating func lowercaseFirst() {
        guard characters.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    }

    /// EZSE: Lowercases first character of String, returns a new string
    public func lowercasedFirst() -> String {
        guard characters.count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }

    /// EZSE: Lowercases first 'count' characters of String
    public mutating func lowercasePrefix(_ count: Int) {
        guard characters.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
    }

    /// EZSE: Lowercases first 'count' characters of String, returns a new string
    public func lowercasedPrefix(_ count: Int) -> String {
        guard characters.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<characters.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<characters.index(startIndex, offsetBy: min(count, length))]).lowercased())
        return result
    }

    /// EZSE: Lowercases last 'count' characters of String
    public mutating func lowercaseSuffix(_ count: Int) {
        guard characters.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
    }

    /// EZSE: Lowercases last 'count' characters of String, returns a new string
    public func lowercasedSuffix(_ count: Int) -> String {
        guard characters.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(characters.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[characters.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
        return result
    }

    /// EZSE: Lowercases string in range 'range' (from range.startIndex to range.endIndex)
    public mutating func lowercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard characters.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
    }

    /// EZSE: Lowercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    public func lowercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard characters.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(characters.index(startIndex, offsetBy: from)..<characters.index(startIndex, offsetBy: to),
                               with: String(self[characters.index(startIndex, offsetBy: from)..<characters.index(startIndex, offsetBy: to)]).lowercased())
        return result
    }

    /// EZSE: Counts whitespace & new lines
    @available(*, deprecated: 1.6, renamed: "isBlank")
    public func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines
        let newText = self.trimmingCharacters(in: characterSet)
        return newText.isEmpty
    }

    /// EZSE: Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }

    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }

    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// EZSE: Position of begining character of substing
    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }

    /// EZSE: split string using a spearator string, returns an array of string
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }

    /// EZSE: split string with delimiters, returns an array of string
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }

    /// EZSE : Returns count of words in string
    public var countofWords: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
        return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
    }

    /// EZSE : Returns count of paragraphs in string
    public var countofParagraphs: Int {
        let regex = try? NSRegularExpression(pattern: "\\n", options: NSRegularExpression.Options())
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (regex?.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(), range: NSRange(location:0, length: str.length)) ?? -1) + 1
    }

    internal func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advanced(by: nsRange.location)
        let to16 = from16.advanced(by: nsRange.length)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    /// EZSE: Find matches of regular expression in string
    public func matchesForRegexInText(_ regex: String!) -> [String] {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length)) ?? []
        return results.map { self.substring(with: self.rangeFromNSRange($0.range)!) }
    }

}

/// EZSE: Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

/// EZSE: Can be used in switch-case
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

/// EZSE: Can be used in switch-case
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}

