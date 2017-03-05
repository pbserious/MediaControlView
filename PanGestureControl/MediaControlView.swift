//
//  ControlView.swift
//  PanGestureControl
//
//  Created by Rattee Wariyawutthiwat on 3/5/2560 BE.
//  Copyright © 2560 Rattee. All rights reserved.
//

import UIKit
import AVFoundation

enum MediaControl {
    case seek
    case volume
    case brightness
}

class MediaControlView:UIView {
    var beganPoint:CGPoint?
    var currentControl:MediaControl?
    var brightnessLevel = UIScreen.main.brightness
    var volumeLevel:Float = 0.0
    
    // Mock
    var avPlayer:AVPlayer?
    var avPlayerLayer:AVPlayerLayer!
    @IBOutlet weak var label:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gesture)

        //Mock
        label?.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Mock
        if avPlayer == nil {
            avPlayer = AVPlayer()
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = self.frame
            self.layer.insertSublayer(avPlayerLayer, at: 0)
            let item = AVPlayerItem(url: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!)
            avPlayer?.replaceCurrentItem(with: item)
            avPlayer?.play()
            if let avPlayer = avPlayer {
                volumeLevel = avPlayer.volume
            }
        } else {
            avPlayerLayer.frame = self.frame
        }
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beganPoint = gesture.location(in: self)
        case .changed:
            guard let beganPoint = beganPoint else {
                return
            }
            let currentPoint = gesture.location(in: self)
            let deltaY = currentPoint.y - beganPoint.y
            let deltaX = currentPoint.x - beganPoint.x
            if currentControl == nil {
                let degree = atan( deltaY / deltaX ) * (180.0 / .pi)
                if abs(degree) > 60 {
                    if beganPoint.x > self.frame.width/2.0 {
                        currentControl = .volume
                    } else {
                        currentControl = .brightness
                    }
                } else {
                    currentControl = .seek
                }
            } else {
                if let currentControl = currentControl {
                    let diffY = (-deltaY)/self.frame.height
                    switch currentControl {
                    case .seek:
                        label?.text = "Seek: \(deltaX/self.frame.width)"
                    case .brightness:
                        handleBrightness(delta: diffY)
                    case .volume:
                        handleVolume(delta: diffY)
                    }
                }
            }
        case .ended:
            currentControl = nil
            brightnessLevel = UIScreen.main.brightness
            if let avPlayer = avPlayer {
                volumeLevel = avPlayer.volume
            }
            //Mock
            label?.text = ""
        default:
            break
        }
    }

    func handleVolume(delta:CGFloat) {
        var newLevel = volumeLevel + Float(delta)
        newLevel = max(0.0, newLevel)
        newLevel = min(1.0, newLevel)
        avPlayer?.volume = newLevel
        //Mock
        label?.text = "Volume: \(newLevel*100.0)"
    }
    
    func handleBrightness(delta:CGFloat) {
        var newLevel = brightnessLevel + delta
        newLevel = max(0.0, newLevel)
        newLevel = min(1.0, newLevel)
        UIScreen.main.brightness = newLevel
        //Mock
        label?.text = "Brightness: \(newLevel*100.0)"
    }
}
