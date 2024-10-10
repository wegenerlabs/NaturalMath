import Foundation

extension NaturalMath {
    // https://en.wikipedia.org/wiki/Shunting_yard_algorithm
    static func shuntingYard(tokens: [NaturalMathToken]) throws -> [NaturalMathToken] {
        var outputQueue = [NaturalMathToken]()
        var operatorStack = [NaturalMathToken]()
        for token in tokens {
            switch token {
            case .number:
                outputQueue.append(token)
            case .plus, .minus, .multiply, .divide, .power, .negate, .sqrt, .ln, .logBase10, .logBase2, .abs, .sin, .cos, .tan, .arcsin, .arccos, .arctan:
                while let last = operatorStack.last,
                      last != .leftParen,
                      last.precedence > token.precedence || (last.precedence == token.precedence && !token.rightAssociative) {
                    outputQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            case .leftParen:
                operatorStack.append(token)
            case .rightParen:
                while let last = operatorStack.last, last != NaturalMathToken.leftParen {
                    outputQueue.append(operatorStack.removeLast())
                }
                guard operatorStack.count > 0 else {
                    throw NaturalMathError.shuntingYardError
                }
                operatorStack.removeLast()
            }
        }
        while operatorStack.count > 0 {
            outputQueue.append(operatorStack.removeLast())
        }
        return outputQueue
    }
}

private extension NaturalMathToken {
    var precedence: Int {
        switch self {
        case .negate, .sqrt, .ln, .logBase10, .logBase2, .abs, .sin, .cos, .tan, .arcsin, .arccos, .arctan:
            return 4
        case .power:
            return 3
        case .multiply, .divide:
            return 2
        case .plus, .minus:
            return 1
        case .number, .leftParen, .rightParen:
            fatalError() // impossible path
        }
    }
    
    var rightAssociative: Bool {
        switch self {
        case .power, .negate, .sqrt, .ln, .logBase10, .logBase2, .abs, .sin, .cos, .tan, .arcsin, .arccos, .arctan:
            return true
        case .plus, .minus, .multiply, .divide:
            return false
        case .number, .leftParen, .rightParen:
            fatalError() // impossible path
        }
    }
}

extension NaturalMathToken: Equatable {
    private var equatableHelper: (Double, Double) {
        switch self {
        case .number(let double):
            return (0, double)
        case .plus:
            return (1, 0)
        case .minus:
            return (2, 0)
        case .multiply:
            return (3, 0)
        case .divide:
            return (4, 0)
        case .power:
            return (5, 0)
        case .negate:
            return (6, 0)
        case .sqrt:
            return (7, 0)
        case .ln:
            return (8, 0)
        case .logBase10:
            return (9, 0)
        case .logBase2:
            return (10, 0)
        case .abs:
            return (11, 0)
        case .sin:
            return (12, 0)
        case .cos:
            return (13, 0)
        case .tan:
            return (14, 0)
        case .arcsin:
            return (15, 0)
        case .arccos:
            return (16, 0)
        case .arctan:
            return (18, 0)
        case .leftParen:
            return (19, 0)
        case .rightParen:
            return (20, 0)
        }
    }
    
    public static func == (lhs: NaturalMathToken, rhs: NaturalMathToken) -> Bool {
        return lhs.equatableHelper == rhs.equatableHelper
    }
}
