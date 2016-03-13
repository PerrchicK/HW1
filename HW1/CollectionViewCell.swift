//
//  CollectionViewCell.swift
//  lesson2
//
//  Created by sapir oded on 3/3/16.
//  Copyright © 2016 sapir oded. All rights reserved.
//
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var backImageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if(imageView == nil) {
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
            if(backImageView==nil) {
                backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                backImageView.contentMode = UIViewContentMode.ScaleAspectFit
                backImageView.image = UIImage(named: "back.png")
                contentView.addSubview(backImageView)
            }
            
            imageView.image = image
        }
    }
    private var isAnimating = false
    private(set) var isFlipped = false
    
    func flipCard(animated: Bool = true) {
        if animated {
            isAnimating = true
            if (!isFlipped) {
                UIView.transitionFromView(backImageView, toView: imageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight) { (done) in
                    self.isAnimating = false
                }
            } else {
                UIView.transitionFromView(imageView, toView: backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft) { (done) in
                    self.isAnimating = false
                }
            }
        } else {
            if (!isFlipped) {
                backImageView.superview?.addSubview(imageView)
                backImageView.removeFromSuperview()
            } else {
                imageView.superview?.addSubview(backImageView)
                imageView.removeFromSuperview()
            }
        }

        isFlipped = !isFlipped
    }
    
    func isClickable() -> Bool {
        return !isFlipped && !self.hidden && !isAnimating
    }
    
    func resetCell() {
        self.hidden = false
    }
}
