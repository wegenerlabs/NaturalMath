import Foundation

extension NaturalMath {
    static func evaluateRPN(tokensRPN: [NaturalMathToken]) throws -> Double {
        var stack = [Double]()
        
        for token in tokensRPN {
            switch token {
            case .number(let value):
                stack.append(value)
            case .plus:
                guard stack.count >= 2 else { throw NaturalMathError.stackError }
                stack.append(stack.removeLast()+stack.removeLast())
            case .minus:
                guard stack.count >= 2 else { throw NaturalMathError.stackError }
                let b = stack.removeLast()
                let a = stack.removeLast()
                stack.append(a-b)
            case .multiply:
                guard stack.count >= 2 else { throw NaturalMathError.stackError }
                stack.append(stack.removeLast()*stack.removeLast())
            case .divide:
                guard stack.count >= 2 else { throw NaturalMathError.stackError }
                let b = stack.removeLast()
                let a = stack.removeLast()
                stack.append(a/b)
            case .power:
                guard stack.count >= 2 else { throw NaturalMathError.stackError }
                let b = stack.removeLast()
                let a = stack.removeLast()
                stack.append(pow(a, b))
            case .negate:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(-stack.removeLast())
            case .sqrt:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(sqrt(stack.removeLast()))
            case .ln:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(log(stack.removeLast()))
            case .logBase10:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(log10(stack.removeLast()))
            case .logBase2:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(log2(stack.removeLast()))
            case .abs:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(abs(stack.removeLast()))
            case .sin:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(sin(stack.removeLast()))
            case .cos:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(cos(stack.removeLast()))
            case .tan:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(tan(stack.removeLast()))
            case .arcsin:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(asin(stack.removeLast()))
            case .arccos:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(acos(stack.removeLast()))
            case .arctan:
                guard stack.count >= 1 else { throw NaturalMathError.stackError }
                stack.append(atan(stack.removeLast()))
            case .leftParen, .rightParen:
                throw NaturalMathError.unexpectedParenthesis // all parentheses should be removed by Shunting-Yard
            }
        }
        
        // we should have exactly one element left
        guard stack.count == 1, var result = stack.first else {
            throw NaturalMathError.stackError
        }
        
        // round the result to remove some floating-point math imprecision
        // e.g. 1+2-3*4/5 would result in 0.6000000000000001 without this
        if result.magnitude < pow(2,32) {
            result = round(result*1_000_000_000)/1_000_000_000
        }
        
        return result
    }
}
