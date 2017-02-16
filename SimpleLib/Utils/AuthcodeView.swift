//
//  AuthcodeView.swift
//  swiftDemo
//
//  Created by LinfangTu on 15/12/7.
//  Copyright © 2015年 LinfangTu. All rights reserved.
//

import UIKit

class AuthcodeView: UIView {
	var dataArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

	var authCodeStr: NSMutableString?

	let kLineCount = 8
	let kCharCount = 6
	let kFontSize = UIFont.systemFont(ofSize: CGFloat(arc4random() % 15) + 15)

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 5.0
		self.layer.masksToBounds = true
		self.backgroundColor = kRandomColor()

		getAuthcode() // 获得随机验证码
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)

		// 设置随机背景颜色
		self.backgroundColor = kRandomColor();

		// 根据要显示的验证码字符串，根据长度，计算每个字符串显示的位置
		let cSize: CGSize = "A".size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)])

		let leg = CGFloat((self.authCodeStr?.length)!)
		let width = rect.size.width / leg - cSize.width
		let height = rect.size.height - cSize.height

		var point: CGPoint

		// 依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
		var pX: CGFloat
		var pY: CGFloat
		let authCodeStrLength = authCodeStr?.length
        //FIXME: 替换i in 0..<authCodeStrLength,编译不通过
		for i in 0 ..< authCodeStrLength!
		{
            pX = CGFloat(arc4random()).truncatingRemainder(dividingBy: width + rect.size.width) / leg * CGFloat(i)
            /* 可先转成Int再用%
             let a = Int(CGFloat(arc4random())), b = Int(width + rect.size.width), c = Int(leg * CGFloat(i)) // Truncate to integer
             也可用 lrint(Double(CGFloat(arc4random()))), 来获取 Round to nearest integer
             pX = a % b / c
             */
			pY = CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
			point = CGPoint(x: pX, y: pY)
			let c: unichar = (self.authCodeStr?.character(at: i))!
			let textC: String = String(describing: UnicodeScalar(c))
			textC.draw(at: point, withAttributes: [NSFontAttributeName: kFontSize])
		}

		// 调用drawRect：之前，系统会向栈中压入一个CGContextRef，调用UIGraphicsGetCurrentContext()会取栈顶的CGContextRef
		let context: CGContext = UIGraphicsGetCurrentContext()!
		// 设置线条宽度
		context.setLineWidth(1.0)
		// 绘制干扰线
		for _ in 0..<kLineCount // var i = 0; i < kLineCount; i++
		{
			let color: UIColor = kRandomColor()
			context.setStrokeColor(color.cgColor) // 设置线条填充色
			// 设置线的起点
			pX = CGFloat(arc4random()) %% rect.size.width
			pY = CGFloat(arc4random()) %% rect.size.height
            context.move(to: CGPoint(x: pX, y: pY)) //swift2: CGContextMoveToPoint(context, pX, pY)
			// 设置线终点
			pX = CGFloat(arc4random()) %% rect.size.width
			pY = CGFloat(arc4random()) %% rect.size.height
            context.addLine(to: CGPoint(x: pX, y: pY)) //swift2: context.addAddLineToPoint(context, pX, pY)
			// 画线
			context.strokePath()
		}
	}

	/**
	 *  获得随机验证码
	 */
	func getAuthcode() {
		self.authCodeStr = NSMutableString(capacity: dataArray.count)
		// 随机从数组中选取需要个数的字符串，拼接为验证码字符串
		for _ in 1...kCharCount {
			let index = Int(arc4random()) % (dataArray.count - 1)

			let tempStr = dataArray[index]
			self.authCodeStr?.append(tempStr)
		}
	}

	/**
	 *  点击界面切换验证码
	 */
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		getAuthcode()
		// setNeedsDisplay调用drawRect方法来实现view的绘制
		setNeedsDisplay()
	}

	private func kRandomColor () -> UIColor {
		return UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1)
	}

}

//TODO: make private infix
infix operator %% /*<--infix operator is required for custom infix char combos*/
/**
 * Brings back simple modulo syntax (was removed in swift 3)
 * Calculates the remainder of expression1 divided by expression2
 * The sign of the modulo result matches the sign of the dividend (the first number). For example, -4 % 3 and -4 % -3 both evaluate to -1
 * EXAMPLE:
 * print(12 %% 5)    // 2
 * print(4.3 %% 2.1) // 0.0999999999999996
 * print(4 %% 4)     // 0
 * NOTE: The first print returns 2, rather than 12/5 or 2.4, because the modulo (%) operator returns only the remainder. The second trace returns 0.0999999999999996 instead of the expected 0.1 because of the limitations of floating-point accuracy in binary computing.
 */
public func %% (left:CGFloat, right:CGFloat) -> CGFloat {
    return left.truncatingRemainder(dividingBy: right)
}
