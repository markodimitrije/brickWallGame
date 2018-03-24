//
//  CT_Constants.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 08/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//




import Foundation

struct CT_Constants {
    struct Values {
        struct BrickTap {
            static let regular: Int = 1
            static let hammerGain: Int = 50
        }
        struct CreditsWorthTaps {
            static let gold: Int = 100//10000
            static let silver: Int = 100
        }
        struct Hammer {
            static let toWait: TimeInterval = 5// 15 // 10 * 60 // [sec]
            static let activeMaxPeriod: TimeInterval = 100 // 10 // 30 // [sec]
        }
        struct SaveEvery {
            static let saveStateEvery_InTaps: Int = 10
        }
        struct CryptoKeys {
            static let secureKey = "i2IrXeIcecgIkHGKRsSr"
        }
    }
    struct Localization {
        static let CT_BUY_FOR = "Strings.CT.BricksBar.BuyFor.staticTxt" // treba Strings...
        static let CT_USE_HAMMER = "Strings.CT.BricksBar.useHammer" // treba Strings...
        static let CT_GAME_OVER_TITLE = "Strings.CT.BricksView.gameOver.title"
        static let CT_GAME_OVER_MSG = "Strings.CT.BricksView.gameOver.msg"
    }
    struct LocalKeys {
        static let ctGameStarts = "ctGameStarts"
        static let ctGameFinished = "ctGameFinished"
        static let ctCounterNumberSaved = "ctCounterNumberSaved"
        static let ctCounterUserClaimedHammerAt = "ctCounterUserClaimedHammerAt"
        static let ctGameFirstStarts = "ctGameFirstStarts"
        static let ctGameUserIsUsingHammer = "ctGameUserIsUsingHammer"
        
        static let getAllCrestWebReqFinishedSuccessfully = "getAllCrestWebReqFinishedSuccessfully"
    }
    
}

let CT_BRICK_TAP_VAL_GAIN = CT_Constants.Values.BrickTap.hammerGain
let CT_BRICK_TAP_VAL_REG = CT_Constants.Values.BrickTap.regular

let CT_GOLD_WORTH_TAPS = CT_Constants.Values.CreditsWorthTaps.gold
let CT_SILVER_WORTH_TAPS = CT_Constants.Values.CreditsWorthTaps.silver

let CT_BUY_FOR = NSLocalizedString(CT_Constants.Localization.CT_BUY_FOR, comment: "")
let CT_USE_HAMMER = NSLocalizedString(CT_Constants.Localization.CT_USE_HAMMER, comment: "")

let CT_HAMMER_TO_WAIT = CT_Constants.Values.Hammer.toWait
let CT_HAMMER_ACTIVE_MAX_TIME = CT_Constants.Values.Hammer.activeMaxPeriod

let CT_SAVE_STATE_EVERY_IN_TAPS = CT_Constants.Values.SaveEvery.saveStateEvery_InTaps


let CT_UD_KEY_GAME_STARTS = CT_Constants.LocalKeys.ctGameStarts
let CT_UD_KEY_GAME_FINISHED = CT_Constants.LocalKeys.ctGameFinished
let CT_UD_KEY_COUNTER_NUM_SAVED = CT_Constants.LocalKeys.ctCounterNumberSaved
let CT_UD_KEY_USER_CLAIMED_HAMMER_AT = CT_Constants.LocalKeys.ctCounterUserClaimedHammerAt
let CT_UD_KEY_GAME_FIRST_STARTS = CT_Constants.LocalKeys.ctGameFirstStarts
let CT_UD_KEY_USER_IS_USING_HAMMER = CT_Constants.LocalKeys.ctGameUserIsUsingHammer

let CT_GAME_OVER_TITLE = NSLocalizedString(CT_Constants.Localization.CT_GAME_OVER_TITLE, comment: "")
let CT_GAME_OVER_MSG = NSLocalizedString(CT_Constants.Localization.CT_GAME_OVER_MSG, comment: "")

let GAME_CRACK_TOTEM_DATA_DOWNLOADED_SUCCESSFULLY = CT_Constants.LocalKeys.getAllCrestWebReqFinishedSuccessfully

let CT_GAME_SECURE_KEY = CT_Constants.Values.CryptoKeys.secureKey
