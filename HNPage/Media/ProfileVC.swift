//
//  ProfileVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/17.
//

import LCDSDK
import UIKit

class ProfileVC: UIViewController, LCDRequestCallBackProtocol, LCDUserInteractionCallBackProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mineVc = LCDAccessUserCenterViewController { config in
            config.delegate = self
            config.viewSize = CGSize(width: getScreenWidth(), height: getScreenHeight())
        }

        addChild(mineVc)
        view.addSubview(mineVc.view)
    }

    func myDebug(_ msg: Any...) {
        print("个人主页", msg)
    }
}

extension ProfileVC: LCDPlayerCallBackProtocol {
    /*! @abstract 视频开始播放的回调 */
//    - (void)drawVideoStartPlay:(UIViewController *)viewController event:(LCDEvent *)event;
    func drawVideoStartPlay(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("开始播放")
    }

    /*! @abstract 视频播放结束的回调（视频结束播放（退出或者中断）） */
//        - void drawVideoOverPlay: (UIViewController *) viewController event: (LCDEvent *) event
    func drawVideoOverPlay(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("播放结束")
    }

    /*! @abstract 视频暂停播放 */
//        - void drawVideoPause: (UIViewController *) viewController event: (LCDEvent *) event
    func drawVideoPause(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("播放暂停")
    }

    /*! @abstract 视频继续播放 */
//        - void drawVideoContinue: (UIViewController *) viewController event: (LCDEvent *) event
    func drawVideoContinue(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("视频继续播放")
    }

    /*! @abstract 视频完整播放结束一遍的回调 */
//        - void drawVideoPlayCompletion: (UIViewController *) viewController event: (LCDEvent *) event
    func drawVideoPlayCompletion(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("视频完整播放结束")
    }
}
