//
//  Utils.swift
//  HNPage
//
//  Created by hainuo on 2022/1/11.
//

import Foundation
import MBProgressHUD
import UIKit

let NR_AppId = "313631"
let NR_AppName = "快码QrCode"

let BUAD_AppId = "5258348"
/*
 * 是否是刘海屏
 */
func isNotchScreen() -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        return false
    }
    return getKeyWindow().safeAreaInsets.bottom > 0
}

func getKeyWindow() -> UIWindow {
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    guard let window = window else {
        return UIApplication.shared.windows.first { $0.windowLevel == UIWindow.Level.normal }!
    }
    return window
}

func getTabBarheight() -> CGFloat {
    return 50 + getSafeBottomHeight()
}

func getNavBarHeight() -> CGFloat {
    return isNotchScreen() ? 88 : 64
}

func getSafeTopMargin() -> CGFloat {
    return isNotchScreen() ? 24 : 0
}

func getSafeBottomHeight() -> CGFloat {
    return isNotchScreen() ? 34 : 0
}

func getScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

func getScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

func rgbaColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

class XHProgressHUD: MBProgressHUD {
    fileprivate class func showText(text: String, icon: String, time: TimeInterval = 1.0) {
        let view = viewWithShow()

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        let img = UIImage(named: "MBProgressHUD.bundle/\(icon)")

        hud.customView = UIImageView(image: img)
        hud.mode = MBProgressHUDMode.customView
        hud.removeFromSuperViewOnHide = true

        hud.hide(animated: true, afterDelay: time)
    }

    class func viewWithShow() -> UIView {
        var window = getKeyWindow()
        if window.windowLevel != UIWindow.Level.normal {
            for tempWin in UIApplication.shared.windows {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin
                    break
                }
            }
        }
        return window
    }

    class func showStatusInfo(_ info: String) {
        let view = viewWithShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = info
    }

    class func dismiss() {
        let view = viewWithShow()
        MBProgressHUD.hide(for: view, animated: true)
    }

    class func showSuccess(_ status: String, time: TimeInterval = 1.0) {
        showText(text: status, icon: "success.png", time: time)
    }

    class func showError(_ status: String, time: TimeInterval = 1.0) {
        showText(text: status, icon: "error.png", time: time)
    }
}
