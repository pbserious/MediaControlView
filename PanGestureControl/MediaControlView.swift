//
//  ControlView.swift
//  PanGestureControl
//
//  Created by Rattee Wariyawutthiwat on 3/5/2560 BE.
//  Copyright © 2560 Rattee. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum MediaControl {
    case seek
    case volume
    case brightness
}

enum SeekDirection {
    case left
    case right
}

class MediaControlView:UIView {
    var beganPoint:CGPoint?
    var currentControl:MediaControl?
    var brightnessLevel = UIScreen.main.brightness
    var volumeLevel:Float = AVAudioSession.sharedInstance().outputVolume
    var isGestureActive = false
    private var lastSeekPoint:CGPoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gesture)
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        if !isGestureActive {
            return
        }
        switch gesture.state {
        case .began:
            beganPoint = gesture.location(in: self)
            lastSeekPoint = beganPoint
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
                        if let lastSeekPoint = lastSeekPoint {
                            let direction:SeekDirection = currentPoint.x - lastSeekPoint.x > 0 ? .right : .left
                            handleSeekBarLevel(delta: deltaX/self.frame.width, direction: direction)
                            self.lastSeekPoint = currentPoint
                        }
                    case .brightness:
                        adjustBrightness(delta: diffY)
                    case .volume:
                        adjustVolume(delta: diffY)
                    }
                }
            }
        case .ended:
            if let control = currentControl {
                handleEndGesture(control: control)
            }
            currentControl = nil
            lastSeekPoint = nil
            brightnessLevel = UIScreen.main.brightness
            volumeLevel = AVAudioSession.sharedInstance().outputVolume
        default:
            break
        }
    }
    
    func handleSeekBarLevel(delta:CGFloat,direction:SeekDirection) {
        
    }
    
    private func adjustVolume(delta:CGFloat) {
        var newLevel = volumeLevel + Float(delta)
        newLevel = max(0.0, newLevel)
        newLevel = min(1.0, newLevel)
        let volumeView = MPVolumeView()
        for view in volumeView.subviews {
            if let slider = view as? UISlider {
                slider.value = newLevel
                handleVolume(newLevel: newLevel)
                break
            }
        }
        
    }
    func handleVolume(newLevel:Float) {
        
    }
    
    private func adjustBrightness(delta:CGFloat) {
        var newLevel = brightnessLevel + delta
        newLevel = max(0.0, newLevel)
        newLevel = min(1.0, newLevel)
        UIScreen.main.brightness = newLevel
        handleBrightness(newLevel: Float(newLevel))
    }
    func handleBrightness(newLevel:Float) {
        
    }
    
    func handleEndGesture(control:MediaControl) {
        
    }
}
