//
//  dankapian.swift
//  HNPage
//
//  Created by hainuo on 2022/1/14.
//

import LCDSDK
import UIKit

class VideoCardSingle: UIViewController {
    let element = LCDVideoSingleCardProvider.shared().buildViewElement()
    let cardSize = CGSize(width: getScreenWidth(), height: getScreenHeight() - getNavBarHeight())
    let cardView = LCDVideoSingleCardProvider.shared().buildView()
    var customView = UIView()
    let titleLabel = UILabel()
    var myTimer: Timer!

    deinit {
        myDebug("移除Timer")
        myTimer.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        LCDVideoSingleCardProvider.shared().shouldShowPlayIcon = true
        LCDVideoSingleCardProvider.shared().shouldShowTitle = true

        LCDVideoSingleCardProvider.shared().delegate = self
        LCDVideoSingleCardProvider.shared().adDelegate = self
        element.configSmartCropSize(CGSize(width: cardSize.width - 60, height: cardSize.height - 40))
        cardView.backgroundColor = .gray
        cardView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cardSize)
        customView.frame = CGRect(origin: CGPoint(x: 0, y: getNavBarHeight()), size: CGSize(width: cardSize.width, height: cardSize.height))
        view.addSubview(customView)
        LCDNativeTrackManager.shareInstance().trackShowEvent(forComponent: cardView)
        titleLabel.frame = CGRect(x: 0, y: 0, width: customView.bounds.width, height: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        customView.addSubview(titleLabel)
        cardView.center = CGPoint(x: customView.bounds.width / 2, y: customView.bounds.height / 2)
        customView.addSubview(cardView)

        reloadElement()
        var timeInterval = 0.0
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] time in

            guard let self = self else {
                time.invalidate()
                return
            }

            timeInterval += time.timeInterval
            self.myDebug(timeInterval, self.element.hasLoadData())
            if timeInterval > 1, Int(timeInterval) % 9 == 0 {
                self.reloadElement()
            }
        }
    }

    func myDebug(_ msg: Any...) {
        print("单卡片视频", msg)
    }

    func reloadElement() {
        element.loadData { [weak self] element, error in
            guard let self = self else {
                return
            }
            self.myDebug("错误信息")
            self.myDebug("资源加载", element.hasLoadData())

            if element.hasLoadData() {
                DispatchQueue.main.async {
                    self.cardView.refreshData(element)
                    self.element.register(self.customView)
                    let model = self.element.nativeDatas().first!
                    self.titleLabel.text = model.title
                }
            } else {
                self.myDebug("资源加载失败", error)
            }
        }
    }
}

extension VideoCardSingle: LCDVideoSingleCardProviderDelegate {
//    - (void)lcdSingleCardClickEvent:(LCDEvent *)event view:(UIView *)view;
    func lcdSingleCardClick(_ event: LCDEvent, view: UIView) {
        myDebug("用户点击了卡片")
    }

//    - (void)lcdNativeDatasChanged:(NSArray<LCDNativeDataModel *> *)newNativeData;
    func lcdNativeDatasChanged(_ newNativeData: [LCDNativeDataModel]) {
        myDebug("原生数据变更了", newNativeData)
        let model = element.nativeDatas().first
        titleLabel.text = model?.title
    }
}

extension VideoCardSingle: LCDAdvertCallBackProtocol {
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
