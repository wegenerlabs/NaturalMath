import Foundation

enum NaturalMathError: Error {
    case invalidNumber(String)
    case unexpectedCharacter(Character)
    case shuntingYardError
    case stackError
    case unexpectedParenthesis
}
