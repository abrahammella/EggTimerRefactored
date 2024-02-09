//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabelEgg: UILabel!
    @IBOutlet weak var progressBarView: UIProgressView!
    var player: AVAudioPlayer?
    let eggTimes: [String: Int] = ["Soft" : 1,"Medium": 7, "Hard": 12]
    var timer = Timer()
    var totalTime = 0
    var secondPassed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBarView.progress = 0.0
    }

    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        self.titleLabelEgg.text = hardness
        totalTime = eggTimes[hardness]! * 60
        startCountdown(minutes: totalTime) {
            self.titleLabelEgg.text = "DONE!"
            self.playSound()
        }
    }
    
    func startCountdown(minutes: Int , updateInterval: TimeInterval = 1, completionHandler: @escaping () -> Void) {
        var remainingTime = minutes
        timer.invalidate()
        self.progressBarView.progress = 0.0

        
        timer = Timer(timeInterval: updateInterval, repeats: true) { timer in
            remainingTime -= Int(updateInterval)
         
            if remainingTime <= 0{
                timer.invalidate()
                completionHandler()
            } else {
                if self.secondPassed <= self.totalTime{
                    self.secondPassed += 1
                    let progressTime: Float = Float(self.secondPassed) / Float(self.totalTime)
                    self.progressBarView.progress = progressTime
                    print(progressTime)
                }
              
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType:"mp3")
            else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    

    
}
