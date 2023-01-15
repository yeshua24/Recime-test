//
//  Double+Extension.swift
//  ReciMe
//
//  Created by Yeshua Lagac on 1/14/23.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    var toFractionString : String {
        
        if floor(self) == self {
            return self.cleanValue
        } else {
            let whole = self.whole
            let fraction = self.fraction
            
            var x = fraction
            var a = x.rounded(.down)
            var (h1, k1, h, k) = (1, 0, Int(a), 1)
            
            while x - a > 1.0E-6 * Double(k) * Double(k) {
                x = 1.0 / (x - a)
                a = x.rounded(.down)
                (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
            }
            
            if self > 0 && whole > 0{
                return "\(whole.cleanValue) \(h)/\(k)"
            } else {
                return "\(h)/\(k)"
            }
        }
       
    }
}

extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}
