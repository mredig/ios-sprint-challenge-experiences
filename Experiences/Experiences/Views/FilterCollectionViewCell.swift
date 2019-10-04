//
//  FilterCollectionViewCell.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
	private let context = CIContext(options: nil)

	var filter: CIFilter? {
		didSet {
			updateViews()
		}
	}
	/// no scaling occurs, so make sure to set an appropriately sized image
	var image: UIImage? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet private var imageView: UIImageView!

	private func updateViews() {
		guard let filter = filter, let image = image else { return }

		guard let ciImage = CIImage(image: image) else { fatalError("No Image available") }
		filter.setValue(ciImage, forKey: kCIInputImageKey)
		#warning("set filter settings")

		guard let ciImageResult = filter.outputImage, let cgImageResult = context.createCGImage(ciImageResult, from: CGRect(origin: .zero, size: image.size)) else { fatalError("No output image") }
		imageView.image = UIImage(cgImage: cgImageResult)
	}
}