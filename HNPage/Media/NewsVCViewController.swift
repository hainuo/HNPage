//
//  NewsVCViewController.swift
//  HNPage
//
//  Created by hainuo on 2022/1/17.
//

import LCDSDK
import UIKit

class NewsVCViewController: UIViewController {
    var hotNewsTextDataHolder: LCDNativeDataHolder!
    var hotNewsTextGuideView: LCDHotNewsTextGuideView!
    var hotNewsBannerView: LCDHotNewsBannerView!
    var hotNewsBannerDataHolder: LCDNativeDataHolder!
    var notiViewDataHolder: LCDNativeDataHolder!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.

        addHotNewsTextGuideView()
        addHotNewsBubbleView()
        addHotNewsBannerView()
        showNotiViewAfterDelay()
    }

    func myDebug(_ msg: Any...) {
        print("单卡片视频", msg)
    }

    func addHotNewsTextGuideView() {
        hotNewsTextDataHolder = LCDNativeDataHolder(sceneType: .textChain)
        hotNewsTextDataHolder.delegate = self
        hotNewsTextDataHolder.adDelegate = self
//        hotNewsTextDataHolder.articleLevel = ._3
        let guideView = LCDHotNewsTextGuideView(frame: CGRect(x: 0, y: getNavBarHeight(), width: getScreenWidth(), height: CGFloat(LCDHotNewsTextGuideViewPreferredHeight))) { config in
            config?.trackComponentPosition = LCDTrackComponentPosition.home
            config?.rootVC = self
            // 轮播滚动时间
            config?.autoScrollTime = 3
            // 单条内容停留时间
            config?.contentDisplayTime = 3
        }
        hotNewsTextGuideView = guideView
        view.addSubview(guideView)
        hotNewsTextDataHolder.loadData { [weak self] nativeModels, extra, error in
            guard let self = self else {
                return
            }

            guard let nativeModels = nativeModels else {
                self.myDebug("没有获取到数据 ")
                if let error = error {
                    self.myDebug("错误信息 ", error)
                }

                if let extra = extra {
                    self.myDebug(" extra ", extra)
                }

                return
            }
            self.myDebug("得到数据", nativeModels)
            for item in nativeModels {
                self.myDebug(item.toJSONString())
            }

            guideView.reloadData(with: self.hotNewsTextDataHolder)
            LCDNativeTrackManager.shareInstance().trackShowEvent(forComponent: guideView)
        }
    }

    func addHotNewsBubbleView() {
        let bubbleView = LCDHotNewsBubbleView(frame: CGRect.zero) { [weak self] config in
            config.trackComponentPosition = .tab2
            config.rootVC = self
            config.customDataHolderBlock = { dataHolder in
                dataHolder.delegate = self
                dataHolder.adDelegate = self
            }
        }
        bubbleView.backgroundColor = .red
        bubbleView.frame = CGRect(x: 0, y: getNavBarHeight() + 150, width: getScreenWidth(), height: 90)
        view.addSubview(bubbleView)
        LCDNativeTrackManager.shareInstance().trackShowEvent(forComponent: bubbleView)
    }

    func addHotNewsBannerView() {
        let bannerView = LCDHotNewsBannerView(frame: CGRect(x: 0, y: getNavBarHeight() + 230, width: getScreenWidth(), height: 200)) { [weak self] config in
            config?.trackComponentPosition = .tab3
            config?.rootVC = self
            config?.infoViewLeftPadding = 12
            config?.infoViewRightPadding = 12
            config?.infoViewPosition = .top
        }

        view.addSubview(bannerView)
        hotNewsBannerView = bannerView
        hotNewsBannerDataHolder = LCDNativeDataHolder(sceneType: .banner)
        hotNewsBannerDataHolder.smartCropSize = bannerView.smartCropSize()

        hotNewsBannerDataHolder.adDelegate = self
        hotNewsBannerDataHolder.delegate = self

        hotNewsBannerDataHolder.loadData { [weak self] nativeModels, extra, error in
            guard let self = self else {
                return
            }
            guard let nativeModels = nativeModels else {
                self.myDebug("没有获取到数据 ")
                if let error = error {
                    self.myDebug("错误信息 ", error)
                }

                if let extra = extra {
                    self.myDebug(" extra ", extra)
                }

                return
            }
            self.myDebug("得到数据", nativeModels)
            for item in nativeModels {
                self.myDebug(item.toJSONString())
            }
            self.hotNewsBannerView.reloadData(with: self.hotNewsBannerDataHolder)
            LCDNativeTrackManager.shareInstance().trackShowEvent(forComponent: bannerView)
        }
    }

    func showNotiViewAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.notiViewDataHolder = LCDNativeDataHolder(sceneType: .inAppPush)
            self.notiViewDataHolder.delegate = self
            self.notiViewDataHolder.adDelegate = self
            self.notiViewDataHolder.articleLevel = ._2
            self.notiViewDataHolder.loadData { [weak self] nativeModels, extra, error in
                guard let self = self else {
                    return
                }
                guard let nativeModels = nativeModels else {
                    self.myDebug("没有获取到数据 ")
                    if let error = error {
                        self.myDebug("错误信息 ", error)
                    }

                    if let extra = extra {
                        self.myDebug(" extra ", extra)
                    }

                    return
                }
                self.myDebug("得到数据", nativeModels)
                for item in nativeModels {
                    self.myDebug(item.toJSONString())
                }

                let notiView = LCDHotNewsNotificationView(frame: CGRect.zero) { config in
                    config?.trackComponentPosition = LCDTrackComponentPosition.me
                }
                notiView.frame = CGRect(x: 0, y: 0, width: getScreenWidth() - 20 * 2, height: 150)
                notiView.reloadData(with: self.notiViewDataHolder)
                notiView.show(in: self.view, onTopY: 150, rootVC: self) { config in
                    config?.appearDuration = 0.5
                    config?.showDuration = 5
                    config?.disappearDuration = 0.3
                }

                LCDNativeTrackManager.shareInstance().trackShowEvent(forComponent: notiView)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hotNewsTextDataHolder.loadData { [weak self] _, _, _ in
            guard let self = self else {
                return
            }
            self.hotNewsTextGuideView.reloadData(with: self.hotNewsTextDataHolder)
        }
    }
}

extension NewsVCViewController: LCDDrawVideoViewControllerDelegate {
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

extension NewsVCViewController: LCDAdvertCallBackProtocol {
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
