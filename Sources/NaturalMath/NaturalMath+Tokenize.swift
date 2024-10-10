import Foundation

extension NaturalMath {
    static func tokenize(string: String) throws -> [NaturalMathToken] {
        var tokens = [NaturalMathToken]()
        var currentNumber = ""
        
        func appendCurrentNumber() throws {
            if currentNumber.isEmpty {
                return
            }
            guard let number = Double(currentNumber) else {
                throw NaturalMathError.invalidNumber(currentNumber)
            }
            tokens.append(.number(number))
            currentNumber = ""
        }
        
        let shortenedString = replaceLongExpressions(string)
        for character in shortenedString {
            if character.isWhitespace {
                continue
            }
            if character == "," && !currentNumber.isEmpty {
                continue
            }
            if character.isNumber || character == "." {
                currentNumber.append(character)
            } else if let token = NaturalMathToken(character: character) {
                try appendCurrentNumber()
                if case .minus = token, tokens.last.succeedingMinusIsUnaryOperator {
                    tokens.append(.negate)
                    continue
                }
                if token.impliedMultiplicationWhenRight && tokens.last?.impliedMultiplicationWhenLeft == true {
                    tokens.append(.multiply)
                }
                tokens.append(token)
            } else {
                throw NaturalMathError.unexpectedCharacter(character)
            }
        }
        try appendCurrentNumber()
        
        parenthesizeExponentials(tokens: &tokens)
        
        return tokens
    }
    
    // exponentials should have greater precedence than functions, e.g. log10^2 is log(10^2) and not (log(10))^2
    // adding parentheses here because increasing the precedence value in Shunting Yard leads to a stack error when the exponent is a function
    private static func parenthesizeExponentials(tokens: inout [NaturalMathToken]) {
        // Example 1:
        // 2^3^2+1
        // 2^3^2)+1
        // 2^(3^2)+1
        // 2^(3^2))+1
        // (2^(3^2))+1
        //
        // Example 2:
        // -2^-3^-2
        // -2^-3^-2)
        // -2^-(3^-2)
        // -2^-(3^-2))
        // -(2^-(3^-2))
        //
        // Example 3:
        // log10^2
        // log10^2)
        // log(10^2)
        var i = tokens.count-2
        while i > 0 {
            let token = tokens[i]
            guard token == .power else {
                i -= 1
                continue
            }
            var numberDetected = false
            // go right, insert closing bracket
            var pendingRightParens = 0
            var r = i+1
            while r < tokens.count {
                if tokens[r].isNumber {
                    numberDetected = true
                } else if tokens[r] == .leftParen {
                    pendingRightParens += 1
                } else if tokens[r] == .rightParen {
                    pendingRightParens -= 1
                }
                if numberDetected && pendingRightParens == 0 {
                    tokens.insert(.rightParen, at: r+1)
                    break
                } else {
                    r += 1
                }
            }
            // go left, insert opening bracket
            var pendingLeftParens = 0
            var l = i-1
            while l >= 0 {
                if tokens[l].isNumber {
                    numberDetected = true
                } else if tokens[l] == .rightParen {
                    pendingLeftParens += 1
                } else if tokens[l] == .leftParen {
                    pendingLeftParens -= 1
                }
                if numberDetected && pendingLeftParens == 0 {
                    tokens.insert(.leftParen, at: l)
                    break
                } else {
                    l -= 1
                }
            }
        }
    }
}

// Unary minus operators have greater precedence than minus operators
// Example:
// -3*4 is (-3)*4 and not -(3*4) but 2-3*4 is 2-(3*4)
// Exponentials have greater precedence than unary minus operators:
// Example:
// -2^-2 is -(2^(-2)) and not (-2)^(-2)
private extension Optional where Wrapped == NaturalMathToken {
    var succeedingMinusIsUnaryOperator: Bool {
        switch self {
        case .none:
            return true
        case .some(let wrapped):
            switch wrapped {
            case .number,
                    .rightParen:
                return false
            case .plus,
                    .minus,
                    .multiply,
                    .divide,
                    .power,
                    .negate,
                    .sqrt,
                    .ln,
                    .logBase10,
                    .logBase2,
                    .abs,
                    .sin,
                    .cos,
                    .tan,
                    .arcsin,
                    .arccos,
                    .arctan,
                    .leftParen:
                return true
            }
        }
    }
}

// {number or right bracket}{function or left bracket} implies multiplication
// Examples:
//  3sqrt4 ==> 3*sqrt4
//  (1+2)sqrt4 ==> (1+2)*sqrt4
//  3(6+7) ==> 3*(6+7)
//  (1+2)(6+7) ==> (1+2)*(6+7)
// Numbers following a bracket or function are not supported
// Examples:
//  (1+2)4
//  sqrt(9)4
private extension NaturalMathToken {
    var impliedMultiplicationWhenRight: Bool {
        switch self {
        case .number,
                .sqrt,
                .ln,
                .logBase10,
                .logBase2,
                .abs,
                .sin,
                .cos,
                .tan,
                .arcsin,
                .arccos,
                .arctan,
                .leftParen:
            return true
        case .plus,
                .minus,
                .multiply,
                .divide,
                .power,
                .rightParen:
            return false
        case .negate:
            fatalError() // impossible path
        }
    }
    
    var impliedMultiplicationWhenLeft: Bool {
        switch self {
        case .number,
                .rightParen:
            return true
        case .plus,
                .minus,
                .multiply,
                .divide,
                .power,
                .negate,
                .sqrt,
                .ln,
                .logBase10,
                .logBase2,
                .abs,
                .sin,
                .cos,
                .tan,
                .arcsin,
                .arccos,
                .arctan,
                .leftParen:
            return false
        }
    }
}
