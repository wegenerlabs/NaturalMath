import Foundation

public class NaturalMath {
    public let input: String
    
    public init(_ input: String) {
        self.input = input
    }
    
    public lazy var tokens: Result<[NaturalMathToken], Error> = {
        do {
            return .success(try NaturalMath.tokenize(string: input))
        } catch {
            return .failure(error)
        }
    }()
    
    public lazy var tokensRPN: Result<[NaturalMathToken], Error> = {
        do {
            return .success(try NaturalMath.shuntingYard(tokens: try tokens.get()))
        } catch {
            return .failure(error)
        }
    }()
    
    public lazy var result: Result<Double, Error> = {
        do {
            return .success(try NaturalMath.evaluateRPN(tokensRPN: try tokensRPN.get()))
        } catch {
            return .failure(error)
        }
    }()
}
