//
//  LCDDrawVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/12.
//

import Foundation
import LCDSDK
class ChenjinshiVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "全屏视频"

        let lcdDVC = LCDDrawVideoViewController { config in
            config.showCloseButton = true
            config.delegate = self
            config.adDelegate = self
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        addChild(lcdDVC)
        view.addSubview(lcdDVC.view)
//        navigationController?.pushViewController(lcdDVC, animated: true)
    }

    func myDebug(_ msg: Any...) {
        print("沉浸式小视频", msg)
    }
}

extension ChenjinshiVC: LCDDrawVideoViewControllerDelegate {
    /*! @abstract 视频切换时的回调，当前索引值 =  event.params[@"position"]，
     drawVideoCurrentVideoChanged在首次进入页面时也会触发
     若当前页为广告，则不会触发此回调 */
//    - (void)drawVideoCurrentVideoChanged:(UIViewController *)viewController event:(LCDEvent *)event;
    func drawVideoCurrentVideoChanged(_ viewController: UIViewController, event: LCDEvent) {
        myDebug("视频切换时的回调 drawVideoCurrentVideoChanged")
    }

    /*! @abstract 加载失败按钮点击重试回调 */
//        - void drawVideoDidClickedErrorButtonRetry: (UIViewController *) viewController
    func drawVideoDidClickedErrorButtonRetry(_ viewController: UIViewController) {
        myDebug("视频加载失败，点击重新加载按钮时的回调 drawVideoDidClickedErrorButtonRetry")
    }

    /*! @abstract 默认关闭按钮被点击的回调 */
//        - void drawVideoCloseButtonClicked: (UIViewController *) viewController
    func drawVideoCloseButtonClicked(_ viewController: UIViewController) {
        myDebug("关闭按钮被点击了 drawVideoCloseButtonClicked")
    }

    /*! @abstract 数据刷新完成回调 */
//        - void drawVideoDataRefreshCompletion: (NSError *) error
    func drawVideoDataRefreshCompletion(_ error: Error) {
        myDebug(" 数据刷新完成的回调 drawVideoDataRefreshCompletion")
    }
}

extension ChenjinshiVC: LCDAdvertCallBackProtocol {
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
        myDebug("填充失败 lcdAdFillFail")
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
