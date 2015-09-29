//
//  IntroViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/23/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate {
    
    // Outlets & Vars ----------------------------------

    @IBOutlet weak var introScrollView: UIScrollView!
    @IBOutlet weak var introBackgroundImageView: UIImageView!
    @IBOutlet weak var introSwipeImageView: UIImageView!
    
    var animationCount = 0
    var hasScrolled = false
    
    @IBOutlet weak var introTile1: UIImageView!
    @IBOutlet weak var introTile2: UIImageView!
    @IBOutlet weak var introTile3: UIImageView!
    @IBOutlet weak var introTile4: UIImageView!
    @IBOutlet weak var introTile5: UIImageView!
    @IBOutlet weak var introTile6: UIImageView!
    
    let couple = Tile(
        startPosition: CGPoint(x: 54.0, y: 537.0),
        endPosition: CGPoint(x: 132.5, y: 815.5),
        startRotation: -15.0,
        endRotation: 0.0,
        startScale: 0.85,
        endScale: 0.89
    )
    
    let deer = Tile(
        startPosition: CGPoint(x: 274.0, y: 536.0),
        endPosition: CGPoint(x: 234.5, y: 782.0),
        startRotation: -12.0,
        endRotation: 0.0,
        startScale: 1.65,
        endScale: 0.89
    )
    
    let fishing = Tile(
        startPosition: CGPoint(x: 251.0, y: 444.5),
        endPosition: CGPoint(x: 234.5, y: 851),
        startRotation: 10.0,
        endRotation: 0.0,
        startScale: 1.6,
        endScale: 0.89
    )
    
    let landscape = Tile(
        startPosition: CGPoint(x: 167.0, y: 545.0),
        endPosition: CGPoint(x: 98.0, y: 919),
        startRotation: 10.0,
        endRotation: 0.0,
        startScale: 1.6,
        endScale: 0.89
    )
    
    let cabin = Tile(
        startPosition: CGPoint(x: 49.5, y: 437.0),
        endPosition: CGPoint(x: 166.5, y: 919),
        startRotation: 8.0,
        endRotation: 0.0,
        startScale: 1.56,
        endScale: 0.89
    )
    
    let woman = Tile(
        startPosition: CGPoint(x: 146, y: 450.0),
        endPosition: CGPoint(x: 234.5, y: 919),
        startRotation: -10.0,
        endRotation: 0.0,
        startScale: 1.6,
        endScale: 0.89
    )
    
    
    // Default Functions -------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introScrollView.delegate = self
        introScrollView.contentSize = introBackgroundImageView.image!.size
        
        // Couple
        introTile1.center = couple.startPosition
        introTile1.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(couple.startRotation), couple.startScale, couple.startScale)
        
        // Deer
        introTile2.center = deer.startPosition
        introTile2.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(deer.startRotation), deer.startScale, deer.startScale)
        
        // Fishing
        introTile3.center = fishing.startPosition
        introTile3.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(fishing.startRotation), fishing.startScale, fishing.startScale)
        
        // Landscape
        introTile4.center = landscape.startPosition
        introTile4.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(landscape.startRotation), landscape.startScale, landscape.startScale)
        
        // Cabin
        introTile5.center = cabin.startPosition
        introTile5.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(cabin.startRotation), cabin.startScale, cabin.startScale)
        
        // Woman & Dog
        introTile6.center = woman.startPosition
        introTile6.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(woman.startRotation), woman.startScale, woman.startScale)
        
        // Animate swipe
        loopSwipeAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Scroll View Tile Effect -------------------------
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Turn off swipe animation
        hasScrolled = true
        
        // Determine percentage scrolled
        var maximumVerticalOffset: CGFloat = introScrollView.contentSize.height - CGRectGetHeight(introScrollView.frame)
        var currentVerticalOffset: CGFloat = introScrollView.contentOffset.y
        var percentage: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        // Interpolate between two values
        if percentage >= 0.0 && percentage <= 1.0 {
            updateAllTiles(percentage)
        } else if percentage < 0.0 {
            percentage = 0.0 // Needed to ensure smooth, glitch-free interpolation
            updateAllTiles(percentage)
        } else if percentage > 1.0 {
            percentage = 1.0 // Needed to ensure smooth, glitch-free interpolation
            updateAllTiles(percentage)
        }
    }
    
    func updateTileTransform(tile: UIImageView, values: Tile, percentage: CGFloat) {
        tile.center = CGPoint(
            x: (values.endPosition.x - values.startPosition.x) * percentage + values.startPosition.x,
            y: (values.endPosition.y - values.startPosition.y) * percentage + values.startPosition.y
        )
        tile.transform = CGAffineTransformScale(
            CGAffineTransformMakeDegreeRotation(
            (values.endRotation - values.startRotation) * percentage + values.startRotation),
            (values.endScale - values.startScale) * percentage + values.startScale,
            (values.endScale - values.startScale) * percentage + values.startScale
        )
    }

    func updateAllTiles(percentage: CGFloat) {
        updateTileTransform(introTile1, values: couple, percentage: percentage)
        updateTileTransform(introTile2, values: deer, percentage: percentage)
        updateTileTransform(introTile3, values: fishing, percentage: percentage)
        updateTileTransform(introTile4, values: landscape, percentage: percentage)
        updateTileTransform(introTile5, values: cabin, percentage: percentage)
        updateTileTransform(introTile6, values: woman, percentage: percentage)
    }


    // Swipe Animation ---------------------------------

    func loopSwipeAnimation() {
        if animationCount < 4 && !hasScrolled {
            animationCount++
            introSwipeImageView.alpha = 0.0
            introSwipeImageView.center = CGPoint(x: 160.0, y: 330.0)
            introSwipeImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                self.introSwipeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.introSwipeImageView.alpha = 1.0
                }, completion: nil)
            UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseIn, animations: { () -> Void in
                self.introSwipeImageView.center = CGPoint(x: 160.0, y: 130.0)
                self.introSwipeImageView.alpha = 0.0
                }, completion: nil)
            delay(3.0, closure: { () -> () in
                self.loopSwipeAnimation()
            })
        }
    }
}


// Struct for Tile Data ----------------------------

struct Tile {
    var startPosition: CGPoint
    var endPosition: CGPoint
    var startRotation: CGFloat
    var endRotation: CGFloat
    var startScale: CGFloat
    var endScale: CGFloat
}