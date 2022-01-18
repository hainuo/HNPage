//
//  JiugonggeVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/13.
//

import LCDSDK
import UIKit

class JiugonggeVC: UIViewController {
    static var lastClickBackTime: TimeInterval = 0
    var vc: LCDGridVideoViewController!
    var grideType: LCDGridVideoVCType = .grid
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        vc = LCDGridVideoViewController { config in
            config.adDelegate = self
            config.delegate = self
            config.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            config.gridVideoVCType = self.grideType
        }
        switch grideType {
        case .waterfall:
            title = "瀑布流"
        case .grid:
            title = "宫格"
        @unknown default:
            title = "unknown"
        }
        addChild(vc)
        vc.view.frame = CGRect(x: 0, y: getNavBarHeight(), width: getScreenWidth(), height: getScreenHeight() - getNavBarHeight())
        view.addSubview(vc.view)
    }

    func myDebug(_ msg: Any...) {
        print("宫格", msg)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension JiugonggeVC: LCDGridVideoViewControllerDelegate {
    /*! @abstract 宫格item点击回调 */
//    - (void)lcdClickGridItemEvent:(LCDEvent *)event controller:(UIViewController *)gridViewController;
    func lcdClickGridItemEvent(_ event: LCDEvent, controller gridViewController: UIViewController) {
        myDebug("宫格item点击回调")
    }

    /*! @abstract 模块曝光 */
//        - void lcdGridItemClientShowEvent: (LCDEvent *) event
    func lcdGridItemClientShow(_ event: LCDEvent) {
        myDebug("模块曝光")
    }

    /*! @abstract 数据刷新完成回调 */
//        - void lcdGridDataRefreshCompletion: (NSError *) error
    func lcdGridDataRefreshCompletion(_ error: Error) {
        myDebug("数据刷新完成回调")
    }
}

extension JiugonggeVC: LCDAdvertCallBackProtocol {
    //    /*! @abstract 发起广告请求 */
    //    - (void)lcdSendAdRequest:(LCDAdTrackEvent *)event;
    func lcdSendAdRequest(_ event: LCDAdTrackEvent) {
        myDebug("lcdSendAdRequest 发起请求")
    }

    /*! @abstract 加载成功 */
    //        - void lcdAdLoadSuccess: (LCDAdTrackEvent *) event
    func lcdAdLoadSuccess(_ event: LCDAdTrackEvent) {
        myDebug("lcdAdLoadSuccess 加载成功")
    }

    /*! @abstract 加载失败 */
    //        - void lcdAdLoadFail: (LCDAdTrackEvent *) event error: (NSError *) error
    func lcdAdLoadFail(_ event: LCDAdTrackEvent, error: Error) {
        myDebug("加载失败 lcdAdLoadFail")
    }

    /*! @abstract 填充失败 */
    //        - void lcdAdFillFail: (LCDAdTrackEvent *) event
    func lcdAdFillFail(_ event: LCDAdTrackEvent) {
        myDebug("填充失败 lcdAdFillFail", event)
    }

    /*! @abstract 广告曝光 */
    //        - void lcdAdWillShow: (LCDAdTrackEvent *) event
    func lcdAdWillShow(_ event: LCDAdTrackEvent) {
        myDebug("广告即将展示 lcdAdWillShow")
    }

    /*! @abstract 视频广告开始播放 */
    //        - void lcdVideoAdStartPlay: (LCDAdTrackEvent *) event
    func lcdVideoAdStartPlay(_ event: LCDAdTrackEvent) {
        myDebug("广告开始播放 lcdVideoAdStartPlay")
    }

    /*! @abstract 视频广告暂停播放 */
    //        - void lcdVideoAdPause: (LCDAdTrackEvent *) event
    func lcdVideoAdPause(_ event: LCDAdTrackEvent) {
        myDebug("广告暂停播放 lcdVideoAdPause")
    }

    /*! @abstract 视频广告继续播放 */
    //        - void lcdVideoAdContinue: (LCDAdTrackEvent *) event
    func lcdVideoAdContinue(_ event: LCDAdTrackEvent) {
        myDebug("广告继续播放 lcdVideoAdContinue")
    }

    /*! @abstract 视频广告停止播放 */
    //        - void lcdVideoAdOverPlay: (LCDAdTrackEvent *) event
    func lcdVideoAdOverPlay(_ event: LCDAdTrackEvent) {
        myDebug("广告停止播放 lcdVideoAdOverPlay")
    }

    /*! @abstract 点击广告 */
    //        - void lcdClickAdViewEvent: (LCDAdTrackEvent *) event
    func lcdClickAdViewEvent(_ event: LCDAdTrackEvent) {
        myDebug("广告被点击了 lcdClickAdViewEvent")
    }
}
