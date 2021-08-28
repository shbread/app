import UIKit

extension NSAttributedString {
    class func make(transform: (NSMutableAttributedString) -> Void) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        transform(mutable)
        return mutable
    }
    
    class func make(_ string: String, font: UIFont, color: UIColor) -> Self {
        .init(string: string, attributes: [
                .font: font,
                .foregroundColor: color])
    }
    
    class func make(_ string: String, font: UIFont, color: UIColor, lineBreak: NSLineBreakMode) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreak
        return .init(string: string, attributes: [
                        .font: font,
                        .foregroundColor: color,
                        .paragraphStyle: paragraph])
    }
}
