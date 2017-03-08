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

class MockMediaControlView:MediaControlView {
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
        } else {
            avPlayerLayer.frame = self.frame
        }
    }

    override func handleSeekBarLevel(delta: CGFloat, direction: SeekDirection) {
        label?.text = "Seek: \(delta)"
    }

    override func handleVolume(newLevel:Float) {
        //Mock
        label?.text = "Volume: \(newLevel*100.0)"
    }
    override func handleBrightness(newLevel:Float) {
        //Mock
        label?.text = "Brightness: \(newLevel*100.0)"
    }
}
