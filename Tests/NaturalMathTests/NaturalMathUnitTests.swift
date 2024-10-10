import XCTest
@testable import NaturalMath

final class NaturalMathUnitTests: XCTestCase {
    func testSimpleExample() {
        let nm = NaturalMath("2+3^4")
        XCTAssertEqual(nm.input, "2+3^4")
        XCTAssertEqual(try! nm.tokens.get(), [
            .number(2),
            .plus,
            .leftParen,
            .number(3),
            .power,
            .number(4),
            .rightParen
        ])
        XCTAssertEqual(try! nm.tokensRPN.get(), [
            .number(2),
            .number(3),
            .number(4),
            .power,
            .plus
        ])
        XCTAssertEqual(try! nm.result.get(), 83)
    }
    
    func testTokenize() {
        XCTAssertEqual(try! NaturalMath.tokenize(string: "2^3^2").tokenString, "(2^(3^2))")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "-2^-3^-2").tokenString, "-(2^-(3^-2))")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "1+2﹢3＋4").tokenString, "1+2+3+4")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "-1-2−3－4–5—6").tokenString, "-1-2-3-4-5-6")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "1*2×3⋅4x5").tokenString, "1*2*3*4*5")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "720/6÷5⁄4:3").tokenString, "720/6/5/4/3")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "(2)[3]{4}").tokenString, "(2)*(3)*(4)")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "log100ln7.38905609893lb4sqrt4(2**2)").tokenString, "㏒100*㏑7.38905609893*l4*√4*((2^2))")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "㏒100*㏑7.38905609893*l4*√4*2^2").tokenString, "㏒100*㏑7.38905609893*l4*√4*(2^2)")
        XCTAssertEqual(try! NaturalMath.tokenize(string: "abs1sin2cos3tan4arcsin5arccos6arctan7asin8acos9atan10").tokenString, "a1*s2*c3*t4*S5*C6*T7*S8*C9*T10")
    }
    
    func testShuntingYard() {
        // 1+2-4*-5
        // 1 2 + 4 5 negate * -
        XCTAssertEqual(try! NaturalMath.shuntingYard(tokens: [
            .number(1),
            .plus,
            .number(2),
            .minus,
            .number(4),
            .multiply,
            .negate,
            .number(5),
            .divide,
            .number(3)
        ]), [
            .number(1),
            .number(2),
            .plus,
            .number(4),
            .number(5),
            .negate,
            .multiply,
            .number(3),
            .divide,
            .minus
        ])
        // (4+5)*6
        // 4 5 + 6 *
        XCTAssertEqual(try! NaturalMath.shuntingYard(tokens: [
            .leftParen,
            .number(4),
            .plus,
            .number(5),
            .rightParen,
            .multiply,
            .number(6)
        ]), [
            .number(4),
            .number(5),
            .plus,
            .number(6),
            .multiply,
        ])
        // 2^3^4
        // 2 3 4 ^ ^
        XCTAssertEqual(try! NaturalMath.shuntingYard(tokens: [
            .number(2),
            .power,
            .number(3),
            .power,
            .number(4)
        ]), [
            .number(2),
            .number(3),
            .number(4),
            .power,
            .power
        ])
        // (log100)^sqrt4
        // 100 log 4 sqrt ^
        XCTAssertEqual(try! NaturalMath.shuntingYard(tokens: [
            .logBase10,
            .leftParen,
            .number(100),
            .rightParen,
            .power,
            .sqrt,
            .number(4)
        ]), [
            .number(100),
            .logBase10,
            .number(4),
            .sqrt,
            .power
        ])
    }
    
    func testEvaluateRPN() {
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .number(4), .plus]), 7)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .number(4), .minus]), -1)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .number(4), .multiply]), 12)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .number(4), .divide]), 0.75)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .number(4), .power]), 81)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(3), .negate]), -3)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(4), .sqrt]), 2)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(7.38905609893), .ln]), 2)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(1000), .logBase10]), 3)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(32), .logBase2]), 5)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(-2), .abs]), 2)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(0), .sin]), 0)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(0), .cos]), 1)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(0), .tan]), 0)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(0), .arcsin]), 0)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(1), .arccos]), 0)
        XCTAssertEqual(try! NaturalMath.evaluateRPN(tokensRPN: [.number(0), .arctan]), 0)
    }
    
    func testNaturalMathTokenEquality() {
        func createCases() -> [NaturalMathToken] {
            return [
                .number(1),
                .number(2),
                .plus,
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
                .leftParen,
                .rightParen
            ]
        }
        let casesA = createCases()
        let casesB = createCases()
        for a in 0..<casesA.count {
            for b in 0..<casesB.count {
                if a == b {
                    XCTAssertEqual(casesA[a], casesB[b])
                } else {
                    XCTAssertNotEqual(casesA[a], casesB[b])
                }
            }
        }
    }
    
    func testCodePoints() {
        XCTAssertEqual("\(NaturalMathToken.plus)+﹢＋".map({$0}).filter({ $0.codePoint?.isPlusCodePoint == true }).count, 4)
        XCTAssertEqual("\(NaturalMathToken.minus)-−－–—".map({$0}).filter({ $0.codePoint?.isMinusCodePoint == true }).count, 6)
        XCTAssertEqual("\(NaturalMathToken.multiply)*×⋅x".map({$0}).filter({ $0.codePoint?.isMultiplyCodePoint == true }).count, 5)
        XCTAssertEqual("\(NaturalMathToken.divide)/÷⁄:".map({$0}).filter({ $0.codePoint?.isDivideCodePoint == true }).count, 5)
        XCTAssertEqual("\(NaturalMathToken.power)^".map({$0}).filter({ $0.codePoint?.isPowerCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.sqrt)√".map({$0}).filter({ $0.codePoint?.isSqrtCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.ln)㏑".map({$0}).filter({ $0.codePoint?.isLnCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.logBase10)㏒".map({$0}).filter({ $0.codePoint?.isLogBase10CodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.logBase2)l".map({$0}).filter({ $0.codePoint?.isLogBase2CodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.abs)a".map({$0}).filter({ $0.codePoint?.isAbsCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.sin)s".map({$0}).filter({ $0.codePoint?.isSinCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.cos)c".map({$0}).filter({ $0.codePoint?.isCosCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.tan)t".map({$0}).filter({ $0.codePoint?.isTanCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.arcsin)S".map({$0}).filter({ $0.codePoint?.isArcsinCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.arccos)C".map({$0}).filter({ $0.codePoint?.isArccosCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.arctan)T".map({$0}).filter({ $0.codePoint?.isArctanCodePoint == true }).count, 2)
        XCTAssertEqual("\(NaturalMathToken.leftParen)([{".map({$0}).filter({ $0.codePoint?.isLeftParenCodePoint == true }).count, 4)
        XCTAssertEqual("\(NaturalMathToken.rightParen))]}".map({$0}).filter({ $0.codePoint?.isRightParenCodePoint == true }).count, 4)
    }
}

extension Array where Element == NaturalMathToken {
    var tokenString: String {
        return map({ "\($0)" }).joined()
    }
}
