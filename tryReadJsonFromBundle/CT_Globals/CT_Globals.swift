//
//  CT_Globals.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 15/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices
import CoreAudioKit

func getFinishedAndStartedAtCrackTotemTimes() -> (finishedAt: Date?, startedAt: Date?) {
    
    return (ud.value(forKey: CT_UD_KEY_GAME_FINISHED) as? Date, ud.value(forKey: CT_UD_KEY_GAME_STARTS) as? Date)
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func makeIphoneVibrate() {
    
    //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//    AudioServicesPlaySystemSound(1519)
    //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    //AudioServicesPlaySystemSoundWithCompletion
//    let s = SystemSoundID(kSystemSoundID_Vibrate)
  //  AudioServicesPlayAlertSound(<#T##inSystemSoundID: SystemSoundID##SystemSoundID#>)
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.prepare()
    generator.impactOccurred()

}


