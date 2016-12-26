//
//  ExtKIT
//  Ext_UIImage.swift
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

public extension UIImage {

	convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(cgImage: (image?.cgImage!)!)
	}

	convenience init(color: UIColor, rect: CGRect) {
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(cgImage: (image?.cgImage!)!)
	}

	/// EZSE: Returns compressed image to rate from 0 to 1
	public func compressImage(rate: CGFloat) -> Data? {
		return UIImageJPEGRepresentation(self, rate)
	}

	/// EZSE: Returns Image size in Bytes
	public func getSizeAsBytes() -> Int {
		return UIImageJPEGRepresentation(self, 1)?.count ?? 0
	}

	/// EZSE: Returns Image size in Kylobites
	public func getSizeAsKilobytes() -> Int {
		let sizeAsBytes = getSizeAsBytes()
		return sizeAsBytes != 0 ? sizeAsBytes / 1024: 0
	}

	/// EZSE: scales image
	public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
		let newSize = CGSize(width: w, height: h)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return newImage
	}

	/// EZSE Returns resized image with width. Might return low quality
	public func resizeWithWidth(_ width: CGFloat) -> UIImage {
		let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

		UIGraphicsBeginImageContext(aspectSize)
		self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return img!
	}

	/// EZSE Returns resized image with height. Might return low quality
	public func resizeWithHeight(_ height: CGFloat) -> UIImage {
		let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

		UIGraphicsBeginImageContext(aspectSize)
		self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return img!
	}

	/// EZSE:
	public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
		return (width * self.size.height) / self.size.width
	}

	/// EZSE:
	public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
		return (height * self.size.width) / self.size.height
	}

	/// EZSE: Returns cropped image from CGRect
	public func croppedImage(_ bound: CGRect) -> UIImage? {
		guard self.size.width > bound.origin.x else {
			debugPrint("EZSE: Your cropping X coordinate is larger than the image width")
			return nil
		}
		guard self.size.height > bound.origin.y else {
			debugPrint("EZSE: Your cropping Y coordinate is larger than the image height")
			return nil
		}
		let scaledBounds: CGRect = CGRect(x: bound.maxX * self.scale, y: bound.maxY * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
		let imageRef = self.cgImage?.cropping(to: scaledBounds)
		let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
		return croppedImage
	}

	/// EZSE: Use current image for pattern of color
	public func withColor(_ tintColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

		let context = UIGraphicsGetCurrentContext()
		context?.translateBy(x: 0, y: self.size.height)
		context?.scaleBy(x: 1.0, y: -1.0);
		context?.setBlendMode(CGBlendMode.normal)

		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
		context?.clip(to: rect, mask: self.cgImage!)
		tintColor.setFill()
		context?.fill(rect)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
		UIGraphicsEndImageContext()

		return newImage
	}

	/// EZSE: Returns the image associated with the URL
	public convenience init?(urlString: String) {
		guard let url = URL(string: urlString) else {
			self.init(data: Data())
			return
		}
		guard let data = try? Data(contentsOf: url) else {
			print("EZSE: No image in URL \(urlString)")
			self.init(data: Data())
			return
		}
		self.init(data: data)
	}

	/// EZSE: Returns an empty image //TODO: Add to readme
	public class func blankImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}

	class func createImageWithColor(_ color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size);
		let context = UIGraphicsGetCurrentContext()

		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}

//	func maskInCircle() {
//		let circle: UIBezierPath = UIBezierPath(ovalInRect: self.bounds)
//		var shapeLayer: CAShapeLayer = CAShapeLayer()
//		shapeLayer.path = circle.CGPath
//		shapeLayer.frame = self.bounds;
//		self.layer.mask = shapeLayer;
//	}
    
}

// Circule profile picture
/*
 var layer : CALayer = self.ProfileImage?.layer
 self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width / 2
 self.ProfileImage.layer.borderWidth = 3.5
 self.ProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
 self.ProfileImage.clipsToBounds = true
 */

// Rectangle Profile shape
/*
 var layer:CALayer = self.ProfileImage.layer!
 layer.shadowPath = UIBezierPath(rect: layer.bounds).CGPath
 layer.shouldRasterize = true;
 layer.rasterizationScale = UIScreen.mainScreen().scale
 layer.borderColor = UIColor.whiteColor().CGColor
 layer.borderWidth = 2.0
 layer.shadowColor = UIColor.grayColor().CGColor
 layer.shadowOpacity = 0.4
 layer.shadowOffset = CGSizeMake(1, 3)
 layer.shadowRadius = 1.5
 self.ProfileImage.clipsToBounds = false
 */
