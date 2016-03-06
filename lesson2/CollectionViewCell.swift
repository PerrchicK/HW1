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
    
    private var image: UIImage?
    var isFlipped = false
    var isCardHidden = false
    var canClick = true
    
    func SetImage(im: UIImage) {
        image = im
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
    
    func FlipCard() {
        if (!isFlipped) {
            UIView.transitionFromView(backImageView, toView: imageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        } else {
            UIView.transitionFromView(imageView, toView: backImageView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        }
        isFlipped = !isFlipped
    }
    
    func HideCard() {
        imageView.removeFromSuperview()
        backImageView.removeFromSuperview()
        imageView = nil
        backImageView = nil
        isCardHidden = true
        isFlipped = false
    }
    
    func CanClick() -> Bool {
        return !isFlipped && canClick && !isCardHidden
    }
    
    func resetCell() {
        canClick = true
        isCardHidden = false
        isFlipped = false
        SetImage(image!)
    }
}