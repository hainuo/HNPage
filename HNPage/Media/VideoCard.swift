//
//  VideoCard.swift
//  HNPage
//
//  Created by hainuo on 2022/1/14.
//

import LCDSDK
import UIKit

class VideoCard: UIViewController {
    var cardType: LCDVideoCardType = .typeDefault
    let element = LCDVideoCardProvider.shared().buildViewElement()
    let cardView = LCDVideoCardProvider.shared().buildView()

    deinit {
        print("nil")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        LCDVideoCardProvider.shared().cardType = cardType
        LCDVideoCardProvider.shared().delegate = self
        LCDVideoCardProvider.shared().adDelegate = self
        LCDVideoCardProvider.shared().rootViewController = self
        cardView.frame = CGRect(x: 0, y: getNavBarHeight(), width: getScreenWidth(), height: getScreenHeight() / 3)
        switch cardType {
        case .typeDefault:
            title = "default 卡片"
        case .type2_4:
            title = "2.4 卡片"
        case .typeCustom:
            break
        @unknown default:
            break
        }
        view.addSubview(cardView)
        reloadElement()
    }

    func myDebug(_ msg: Any...) {
        print("单卡片视频", msg)
    }

    func reloadElement() {
        element.loadData { element, error in
            self.myDebug("错误信息")
            self.myDebug("资源加载", element.hasLoadData())

            if element.hasLoadData() {
                DispatchQueue.main.async {
                    self.cardView.refreshData(element)
                }
            } else {
                self.myDebug("资源加载失败", error)
            }
        }
    }
}

extension VideoCard: LCDVideoCardProviderDelegate {
//    - (void)lcdVideoCardClickCellEvent:(LCDEvent *)event cardView:(UIView<LCDVideoCardView> *)cardView;
    func lcdVideoCardClickCellEvent(_ event: LCDEvent, cardView: UIView & LCDVideoCardView) {
        myDebug("内容被点击了")
    }

//    - (void)lcdVideoCardSwipeEnter:(NSDictionary * _Nullable)params cardView:(UIView<LCDVideoCardView> *)cardView;
    func lcdVideoCardSwipeEnter(_ params: [AnyHashable: Any]?, cardView: UIView & LCDVideoCardView) {
        myDebug("内容被滑动了")
    }
}

extension VideoCard: LCDAdvertCallBackProtocol {
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
