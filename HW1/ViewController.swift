//
//  ViewController.swift
//  lesson2
//
//  Created by sapir oded on 3/3/16.
//  Copyright © 2016 sapir oded. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var timeCounter: UILabel!
    var count = 0
    var flipCount = 0
    var images: [UIImage] = []
    var flippedImages: [UIImage] = []
    var mtimer : NSTimer?
    var score : UIView!

    var checkWinLoopsCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initGame()
    }

    func initGame() {
        timeCounter.text = "00:00"
        count = 0
        scheduleTimer()
        let bg = UIImage(named: "bg.jpg")
        view.backgroundColor = UIColor(patternImage: bg!)
        
        initImages()
    }

    func initImages() {
        for var i=1;i<=8;i++ {
            for var j=0;j<2;j++ {
                let imageSource = UIImage(named: "pic\(i).jpg")
                images.append(imageSource!)
            }
        }
    }

    func updateTimeLabel() {
        count++
        let minutes = count / 60
        let minutesS = minutes/10>0 ? String(minutes) : "0\(minutes)"
        let seconds = count - (count/60)*60
        let secondsS = seconds/10>0 ? String(seconds) : "0\(seconds)"
        
        timeCounter.text = "\(minutesS):\(secondsS)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 70, height: 70)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("Dequeuing cell \(indexPath.row), \(indexPath.section)")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath) as! CollectionViewCell
        
        let random = arc4random_uniform(UInt32(images.count))
        let imageSource = images[Int(random)]
        cell.image = imageSource
        images.removeAtIndex(Int(random))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        
        if(cell.isClickable() && flipCount<2) {
            cell.flipCard()
            flippedImages.append(cell.imageView.image!)
            flipCount++
        }
        
        if(flipCount==2) {
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "delayedAction:", userInfo: collectionView, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

            flipCount = 0
            collectionView.userInteractionEnabled = false
        }
        
        print("Selected cell \(indexPath.row), \(indexPath.section)")
    }
    
    func delayedAction(timer: NSTimer!) {
        checkWinLoopsCounter = 0

        // Using a safe and easy Swifty way to pull out the collection view
        if let collectionView = timer.userInfo as? UICollectionView { // Very nice to add this a a userInfo of the timer
            collectionView.userInteractionEnabled = true
            for var i=0;i<collectionView.numberOfSections();i++ {
                for var j=0;j<collectionView.numberOfItemsInSection(i);j++ {
                    let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: j, inSection: i)) as! CollectionViewCell
                    if(cell.isFlipped) {
                        if(flippedImages[0].isEqual(flippedImages[1])) {
                            cell.hidden = true
                            checkWin(collectionView) // Can you see the crazy nested loop here? ( numberOfSections() * numberOfItemsInSection(i) ) ^ 2
                        }
                        cell.flipCard()
                    }
                }
            }
            flippedImages.removeAll()
        }

        print("checkWin nested loop counter = \(checkWinLoopsCounter)")
    }
    
    func checkWin(collectionView : UICollectionView) {

        var win = true
        for var i=0;i<collectionView.numberOfSections();i++ {
            for var j=0;j<collectionView.numberOfItemsInSection(i);j++ {
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: j, inSection: i)) as! CollectionViewCell
                // Runs too many times
                checkWinLoopsCounter++
                if(cell.hidden == false) {
                    win = false
                    break
                }
            }
        }

        if(win) {
            mtimer?.invalidate()
            mtimer = nil
            popup()
            view.addSubview(score)
        }
    }
    
    func popup() {
        let star = UIImage(named: "star.png")
        let nostar = UIImage(named: "nostar.png")
        score = UIView(frame: CGRect(x: 5, y: view.frame.height/2-150, width: view.frame.width-10, height: 220))
        score.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        
        let image1 = UIImageView(frame: CGRect(x: 50, y: 40, width: 80, height: 80))
        let image2 = UIImageView(frame: CGRect(x: view.frame.width/2-50, y: 20, width: 100, height: 100))
        let image3 = UIImageView(frame: CGRect(x: view.frame.width-130, y: 40, width: 80, height: 80))
        
        if(count<=45) {
            image1.image = star
            image2.image = star
            image3.image = star
        }
        else if(count<=75) {
            image1.image = star
            image2.image = nostar
            image3.image = star
        }
        else if(count<=120) {
            image1.image = star
            image2.image = nostar
            image3.image = nostar
        }
        else {
            image1.image = nostar
            image2.image = nostar
            image3.image = nostar
        }
        
        
        score.addSubview(image1)
        score.addSubview(image2)
        score.addSubview(image3)
        
        let scoreLabel = UILabel(frame: CGRect(x: 50, y: 140, width: view.frame.width-50, height: 30))
        scoreLabel.text = "Score: "
        scoreLabel.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        scoreLabel.font = scoreLabel.font.fontWithSize(30)
        score.addSubview(scoreLabel)
        
        // score calculation
        var num = 50 + (120-count)*10
        if(num < 50) {
            num = 50
        }
        scoreLabel.text! += "\(num)"
        
        let play = UIButton(frame: CGRect(x: view.frame.width/2-50, y: 180, width: 100, height: 50))
        play.setTitle("Play again", forState: UIControlState.Normal)
        play.titleLabel?.font = play.titleLabel?.font.fontWithSize(20)
        play.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.6, alpha: 0.8)
        play.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        score.addSubview(play)
    }
    
    func pressed(sender: UIButton!) {
        // Should be called by the OS, not by the controller.
//        self.viewDidLoad() - Calling a system event isn't recommended at all, in that case it doesn't harm but be careful with that
        initGame()

        // Reset cells
        for var i=0;i<mCollectionView.numberOfSections();i++ {
            for var j=0;j<mCollectionView.numberOfItemsInSection(i);j++ {
                let cell = mCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: j, inSection: i)) as! CollectionViewCell
                cell.resetCell()
            }
        }
        score.removeFromSuperview()
    }
    
    @IBAction func PausePressed(sender: UIButton) {
        if(sender.titleLabel!.text == "Pause") { // It's cool to use the sender, but it's a bad practice to use its text for logic conditions
            mtimer?.invalidate()
            mCollectionView.userInteractionEnabled = false
            sender.setTitle("Resume", forState: UIControlState.Normal)
        }
        else {
            scheduleTimer()
            mCollectionView.userInteractionEnabled = true
            sender.setTitle("Pause", forState: UIControlState.Normal)
        }
    }

    private func scheduleTimer() {
        mtimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimeLabel"), userInfo: nil, repeats: true)
    }
}
