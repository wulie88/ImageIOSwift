//
//  Properties.swift
//  ImageService
//
//  Created by David Beck on 10/5/17.
//  Copyright © 2017 David Beck. All rights reserved.
//

import Foundation
import ImageIO


extension ImageSource {
	public struct Properties {
		public let rawValue: [CFString:Any]
		
		public init(rawValue: [CFString:Any]) {
			self.rawValue = rawValue
		}
		
		
		// MARK: - Top level
		
		public var fileSize: Int? {
			return rawValue[kCGImagePropertyFileSize] as? Int
		}
		
		public var pixelWidth: CGFloat? {
			return rawValue[kCGImagePropertyPixelWidth] as? CGFloat
		}
		
		public var pixelHeight: CGFloat? {
			return rawValue[kCGImagePropertyPixelHeight] as? CGFloat
		}
		
		public var imageSize: CGSize? {
			guard var width = pixelWidth, var height = pixelHeight else { return nil }
			
			switch tiff?.orientation ?? 1 {
			case 5...8: // http://magnushoff.com/jpeg-orientation.html
				swap(&width, &height)
			default: break
			}
			
			return CGSize(width: width, height: height)
		}
		
		
		// MARK: - Aggregate
		
		public var loopCount: Int {
			return gif?.loopCount ?? png?.loopCount ?? 1
		}
		
		public var clampedDelayTime: Double? {
			return gif?.clampedDelayTime ?? png?.clampedDelayTime
		}
		
		public var unclampedDelayTime: Double? {
			return gif?.unclampedDelayTime ?? png?.unclampedDelayTime
		}
		
		public var delayTime: Double? {
			return gif?.delayTime ?? png?.delayTime
		}
		
		
		// MARK: -
		
		public struct GIFProperties {
			public let rawValue: [CFString:Any]
			
			public init(rawValue: [CFString:Any]) {
				self.rawValue = rawValue
			}
			
			public var loopCount: Int {
				return rawValue[kCGImagePropertyGIFLoopCount] as? Int ?? 1
			}
			
			public var clampedDelayTime: Double? {
				guard
					let delay = rawValue[kCGImagePropertyGIFDelayTime] as? Double,
					delay > 0
				else { return nil }
				return delay
			}
			
			public var unclampedDelayTime: Double? {
				guard
					let delay = rawValue[kCGImagePropertyGIFUnclampedDelayTime] as? Double,
					delay > 0
					else { return nil }
				return delay
			}
			
			public var delayTime: Double? {
				return unclampedDelayTime ?? clampedDelayTime
			}
			
			public var hasGlobalColorMap: Bool {
				return rawValue[kCGImagePropertyGIFHasGlobalColorMap] as? Bool ?? false
			}
		}
		
		public var gif: GIFProperties? {
			guard let rawValue = self.rawValue[kCGImagePropertyGIFDictionary] as? [CFString:Any] else { return nil }
			
			return GIFProperties(rawValue: rawValue)
		}
		
		
		// MARK: - PNG
		
		public struct PNGProperties {
			public let rawValue: [CFString:Any]
			
			public init(rawValue: [CFString:Any]) {
				self.rawValue = rawValue
			}
			
			public var loopCount: Int {
				return rawValue[kCGImagePropertyAPNGLoopCount] as? Int ?? 1
			}
			
			public var clampedDelayTime: Double? {
				guard
					let delay = rawValue[kCGImagePropertyAPNGDelayTime] as? Double,
					delay > 0
					else { return nil }
				return delay
			}
			
			public var unclampedDelayTime: Double? {
				guard
					let delay = rawValue[kCGImagePropertyAPNGUnclampedDelayTime] as? Double,
					delay > 0
					else { return nil }
				return delay
			}
			
			public var delayTime: Double? {
				return unclampedDelayTime ?? clampedDelayTime
			}
		}
		
		public var png: PNGProperties? {
			guard let rawValue = self.rawValue[kCGImagePropertyPNGDictionary] as? [CFString:Any] else { return nil }
			
			return PNGProperties(rawValue: rawValue)
		}
		
		
		// MARK: - JPEG
		
		public struct JPEGProperties {
			public let rawValue: [CFString:Any]
			
			public init(rawValue: [CFString:Any]) {
				self.rawValue = rawValue
			}
			
			public var xDensity: CGFloat? {
				return rawValue[kCGImagePropertyJFIFXDensity] as? CGFloat
			}
			
			public var yDensity: CGFloat? {
				return rawValue[kCGImagePropertyJFIFYDensity] as? CGFloat
			}
			
			public var orientation: Int? {
				return rawValue[kCGImagePropertyOrientation] as? Int
			}
		}
		
		public var jpeg: JPEGProperties? {
			guard let rawValue = self.rawValue[kCGImagePropertyJFIFDictionary] as? [CFString:Any] else { return nil }
			
			return JPEGProperties(rawValue: rawValue)
		}
		
		
		// MARK: - TIFF
		
		public struct TIFFProperties {
			public let rawValue: [CFString:Any]
			
			public init(rawValue: [CFString:Any]) {
				self.rawValue = rawValue
			}
			
			public var orientation: Int? {
				return rawValue[kCGImagePropertyTIFFOrientation] as? Int
			}
			
			public var xResolution: Int? {
				return rawValue[kCGImagePropertyTIFFXResolution] as? Int
			}
			
			public var yResolution: Int? {
				return rawValue[kCGImagePropertyTIFFYResolution] as? Int
			}
		}
		
		public var tiff: TIFFProperties? {
			guard let rawValue = self.rawValue[kCGImagePropertyTIFFDictionary] as? [CFString:Any] else { return nil }
			
			return TIFFProperties(rawValue: rawValue)
		}
	}
}