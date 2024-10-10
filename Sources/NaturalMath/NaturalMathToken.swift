import Foundation

public enum NaturalMathToken {
    case number(Double)
    case plus
    case minus
    case multiply
    case divide
    case power
    case negate
    case sqrt
    case ln
    case logBase10
    case logBase2
    case abs
    case sin
    case cos
    case tan
    case arcsin
    case arccos
    case arctan
    case leftParen
    case rightParen
    
    public init?(character: Character) {
        guard let codePoint = character.codePoint else {
            return nil
        }
        if codePoint.isPlusCodePoint {
            self = .plus
        } else if codePoint.isMinusCodePoint {
            self = .minus
        } else if codePoint.isMultiplyCodePoint {
            self = .multiply
        } else if codePoint.isDivideCodePoint {
            self = .divide
        } else if codePoint.isPowerCodePoint {
            self = .power
        } else if codePoint.isSqrtCodePoint {
            self = .sqrt
        } else if codePoint.isLnCodePoint {
            self = .ln
        } else if codePoint.isLogBase10CodePoint {
            self = .logBase10
        } else if codePoint.isLogBase2CodePoint {
            self = .logBase2
        } else if codePoint.isAbsCodePoint {
            self = .abs
        } else if codePoint.isSinCodePoint {
            self = .sin
        } else if codePoint.isCosCodePoint {
            self = .cos
        } else if codePoint.isTanCodePoint {
            self = .tan
        } else if codePoint.isArcsinCodePoint {
            self = .arcsin
        } else if codePoint.isArccosCodePoint {
            self = .arccos
        } else if codePoint.isArctanCodePoint {
            self = .arctan
        } else if codePoint.isECodePoint {
            self = .number(exp(1))
        } else if codePoint.isPiCodePoint {
            self = .number(Double.pi)
        } else if codePoint.isLeftParenCodePoint {
            self = .leftParen
        } else if codePoint.isRightParenCodePoint {
            self = .rightParen
        } else {
            return nil
        }
    }
    
    public var isNumber: Bool {
        if case .number = self {
            return true
        }
        return false
    }
    
    public var isParenthesis: Bool {
        if case .leftParen = self {
            return true
        }
        if case .rightParen = self {
            return true
        }
        return false
    }
}

extension UInt32 {
    var isPlusCodePoint: Bool {
        return self == 0x002B || self == 0xFE62 || self == 0xFF0B
    }
    
    var isMinusCodePoint: Bool {
        return self == 0x002D || self == 0x2212 || self == 0xFF0D || self == 0x2013 || self == 0x2014
    }
    
    var isMultiplyCodePoint: Bool {
        return self == 0x002A || self == 0x00D7 || self == 0x22C5 || self == 0x0078
    }
    
    var isDivideCodePoint: Bool {
        return self == 0x002F || self == 0x00F7 || self == 0x2044 || self == 0x003A
    }
    
    var isPowerCodePoint: Bool {
        return self == 0x005E
    }
    
    var isSqrtCodePoint: Bool {
        return self == 0x221A
    }
    
    var isLnCodePoint: Bool {
        return self == 0x33D1
    }
    
    var isLogBase10CodePoint: Bool {
        return self == 0x33D2
    }
    
    var isLogBase2CodePoint: Bool {
        return self == 0x006C
    }
    
    var isAbsCodePoint: Bool {
        return self == 0x0061
    }
    
    var isSinCodePoint: Bool {
        return self == 0x0073
    }
    
    var isCosCodePoint: Bool {
        return self == 0x0063
    }
    
    var isTanCodePoint: Bool {
        return self == 0x0074
    }
    
    var isArcsinCodePoint: Bool {
        return self == 0x0053
    }
    
    var isArccosCodePoint: Bool {
        return self == 0x0043
    }
    
    var isArctanCodePoint: Bool {
        return self == 0x0054
    }
    
    var isECodePoint: Bool {
        return self == 0x0065
    }
    
    var isPiCodePoint: Bool {
        return self == 0x03C0
    }
    
    var isLeftParenCodePoint: Bool {
        return self == 0x0028 || self == 0x005B || self == 0x007B
    }
    
    var isRightParenCodePoint: Bool {
        return self == 0x0029 || self == 0x005D || self == 0x007D
    }
}

extension Character {
    var codePoint: UInt32? {
        guard unicodeScalars.count == 1 else {
            return nil
        }
        return unicodeScalars.first?.value
    }
}

extension NaturalMathToken: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .number(let double):
            guard double.magnitude < Double(Int.max) else {
                return String(double)
            }
            let int = Int(double)
            guard Double(int) == double else {
                return String(double)
            }
            return String(int)
        case .plus:
            return NaturalMath.plusSymbol
        case .minus:
            return NaturalMath.minusSymbol
        case .multiply:
            return NaturalMath.multiplySymbol
        case .divide:
            return NaturalMath.divideSymbol
        case .power:
            return NaturalMath.powerSymbol
        case .negate:
            return NaturalMath.negateSymbol
        case .sqrt:
            return NaturalMath.sqrtSymbol
        case .ln:
            return NaturalMath.lnSymbol
        case .logBase10:
            return NaturalMath.logBase10Symbol
        case .logBase2:
            return NaturalMath.logBase2Symbol
        case .abs:
            return NaturalMath.absSymbol
        case .sin:
            return NaturalMath.sinSymbol
        case .cos:
            return NaturalMath.cosSymbol
        case .tan:
            return NaturalMath.tanSymbol
        case .arcsin:
            return NaturalMath.arcsinSymbol
        case .arccos:
            return NaturalMath.arccosSymbol
        case .arctan:
            return NaturalMath.arctanSymbol
        case .leftParen:
            return NaturalMath.leftParenSymbol
        case .rightParen:
            return NaturalMath.rightParenSymbol
        }
    }
}

extension NaturalMath {
    static let plusSymbol = "+"
    static let minusSymbol = "-"
    static let multiplySymbol = "*"
    static let divideSymbol = "/"
    static let powerSymbol = "^"
    static let negateSymbol = minusSymbol
    static let sqrtSymbol = "√"
    static let lnSymbol = "㏑"
    static let logBase10Symbol = "㏒"
    static let logBase2Symbol = "l"
    static let absSymbol = "a"
    static let sinSymbol = "s"
    static let cosSymbol = "c"
    static let tanSymbol = "t"
    static let arcsinSymbol = "S"
    static let arccosSymbol = "C"
    static let arctanSymbol = "T"
    static let eSymbol = "e"
    static let piSymbol = "π"
    static let leftParenSymbol = "("
    static let rightParenSymbol = ")"
    
    static let powerLongExpression = "**"
    static let sqrtLongExpression = "sqrt"
    static let lnLongExpression = "ln"
    static let logBase10LongExpression = "log"
    static let logBase2LongExpression = "lb"
    static let absLongExpression = "abs"
    static let sinLongExpression = "sin"
    static let cosLongExpression = "cos"
    static let tanLongExpression = "tan"
    static let arcsinLongExpression1 = "arcsin"
    static let arccosLongExpression1 = "arccos"
    static let arctanLongExpression1 = "arctan"
    static let arcsinLongExpression2 = "asin"
    static let arccosLongExpression2 = "acos"
    static let arctanLongExpression2 = "atan"
    static let piLongExpression = "pi"
    
    static func replaceLongExpressions(_ string: String) -> String {
        return string
            .replacingOccurrences(of: powerLongExpression, with: powerSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: sqrtLongExpression, with: sqrtSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: lnLongExpression, with: lnSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: logBase10LongExpression, with: logBase10Symbol, options: [.caseInsensitive])
            .replacingOccurrences(of: logBase2LongExpression, with: logBase2Symbol, options: [.caseInsensitive])
            .replacingOccurrences(of: absLongExpression, with: absSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arcsinLongExpression1, with: arcsinSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arccosLongExpression1, with: arccosSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arctanLongExpression1, with: arctanSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arcsinLongExpression2, with: arcsinSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arccosLongExpression2, with: arccosSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: arctanLongExpression2, with: arctanSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: sinLongExpression, with: sinSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: cosLongExpression, with: cosSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: tanLongExpression, with: tanSymbol, options: [.caseInsensitive])
            .replacingOccurrences(of: piLongExpression, with: piSymbol, options: [.caseInsensitive])
    }
}
