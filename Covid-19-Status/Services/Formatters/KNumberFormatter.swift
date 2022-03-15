import Foundation

open class KNumberFormatter : NumberFormatter {
    
    open func kString(for obj: Any?) -> String? {
        if let num = obj as? NSNumber {
            let suffixes = ["", "K", "M", "B"]
            var idx = 0
            var d = num.doubleValue
            while idx < 4 && abs(d) >= 1000.0 {
                d /= 1000.0
                idx += 1
            }
            var currencyCode = ""
            if self.currencySymbol != nil {
                currencyCode = self.currencySymbol!
            }

            let numStr = String(format: "%.1f", d)

            return currencyCode + numStr + suffixes[idx]
        }
        return nil
    }
    
}
