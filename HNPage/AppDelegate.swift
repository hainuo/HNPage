//
//  AppDelegate.swift
//  HNPage
//
//  Created by hainuo on 2022/1/11.
//

import BUAdSDK
import CoreData
import LCDSDK
import RangersAppLog
import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // MARK: 穿山甲广告

        BUAdSDKManager.setAppID(BUAD_AppId)
        BUAdSDKManager.setUserExtData(nil)

        #if DEBUG
        BUAdSDKManager.setLoglevel(.debug)
        #endif

        // MARK: 穿山甲小视频内容模块

        let lcdConfig = LCDConfig()
        lcdConfig.authorityDelegate = self

        #if DEBUG
        lcdConfig.logLevel = .debug
        #endif

        let configPath = Bundle.main.path(forResource: "SDK_Setting_5258348", ofType: "json")!
        LCDManager.start(withConfigPath: configPath, config: lcdConfig) { status in
            if status == LCDINITStatus.success {
                print("初始化成功！")

//                LCDManager.setPersonalizationRecommendation(true)
            } else {
                print("初始化失败！")
            }
        }

        // MARK: 应用监听

        let config = BDAutoTrackConfig(appID: NR_AppId, launchOptions: launchOptions)
        config.appID = NR_AppId
        config.appName = NR_AppName
        config.channel = "App Store"
        config.abEnable = false
        #if DEBUG
        config.showDebugLog = true
        config.logger = { log in
            print("mylog +++++ \(log as Any)")
        }
        #endif
        config.serviceVendor = .CN
        config.showDebugLog = false
        config.autoTrackEnabled = true

        BDAutoTrack.start(with: config)

        // MARK: push通知事件

        // -- 注册推送
        let center = UNUserNotificationCenter.current()
        center.delegate = self as UNUserNotificationCenterDelegate
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .notDetermined {
                // 未注册
                center.requestAuthorization(options: [.badge, .sound, .alert]) { result, error in
                    print("显示内容：\(result) error：\(String(describing: error))")
                    if result {
                        if !(error != nil) {
                            print("注册成功了！")
                            application.registerForRemoteNotifications()
                        }
                    } else {
                        print("用户不允许推送")
                    }
                }
            } else if setting.authorizationStatus == .denied {
                // 用户已经拒绝推送通知
                // -- 弹出页面提示用户去显示

            } else if setting.authorizationStatus == .authorized {
                // 已注册 已授权 --注册同志获取 token
                // 请求授权时异步进行的，这里需要在主线程进行通知的注册
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }

            } else {}
        }
        // 移除所有的通知
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        // MARK: Novel初始化

        BDNovelPublicConfig.start { [weak self] config in
            guard let self = self else {
                return
            }
            config.configPath = Bundle.main.path(forResource: "SDK_Setting_5258348", ofType: "json")
            config.logger = { log in
                print(" 小说日志 ", log as Any)
            }
            config.userInterfaceStyleCallback = {
                self.novelUIUserInterfaceStyle()
            }
        } completion: { [weak self] error in
            guard self != nil else {
                return
            }
            guard let error = error else {
                return
            }
            print(error)
        }

        // MARK: 设置小说的 UserAgent

        configNovelUserAgent()

        // MARK: rootViewController

        let vc = UINavigationController(rootViewController: ViewController())
        window?.backgroundColor = .systemBackground
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }

    func toutiaoUA() -> String {
        let ua = NSMutableString()
//        let bundleInfo = Bundle.main.infoDictionary!
//        var appName = bundleInfo["CFBundleName"]
//
//        var marketingVersionNumber = bundleInfo["CFBundleShortVersionString"]
//        var developmentVersionNumber = bundleInfo["CFBundleVersion"]

        return ua.copy() as! String
    }

    func configNovelUserAgent() {
        var userAgent = UserDefaults.standard.object(forKey: "UserAgent")
        if userAgent == nil {
            let wkview = WKWebView(frame: CGRect.zero)
            userAgent = wkview.value(forKey: "userAgent")
            if userAgent == nil {
                userAgent = wkview.evaluateJavaScript("navigator.userAgent")
            }
        }
        if userAgent != nil {
            UserDefaults.standard.register(defaults: ["UserAgent": userAgent!])
        }
    }

    func novelUIUserInterfaceStyle() -> BDNovelUIUserInterfaceStyle {
        let kBDNovelDarkMode = "深褐色模式"
        let novelResultNumber = UserDefaults.standard.integer(forKey: kBDNovelDarkMode)
        if novelResultNumber == 0 {
            return BDNovelUIUserInterfaceStyle.unspecified
        } else if novelResultNumber == 1 {
            return BDNovelUIUserInterfaceStyle.dark
        } else {
            return BDNovelUIUserInterfaceStyle.light
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
          The persistent container for the application. This implementation
          creates and returns a container, having loaded the store for the
          application to it. This property is optional since there are legitimate
          error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "HNPage")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        LCDManager.stopOpenGLESActivity()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        LCDManager.startOpenGLESActivity()
    }
}

extension AppDelegate: LCDAuthorityConfigDelegate {
    // MARK: 青少年模式开关

    func turnOnTeenMode() -> Bool {
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func myDebug(_ msg: Any...) {
        print("push消息推送 ", msg)
    }

    // MARK: 接收到推送时 如果应用在后台或者应用被kill 走的是这个delegat

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        myDebug("得到消息 ", userInfo)
        let groupID = userInfo["group_id"]
        let categoryName = userInfo["category_name"]
        // 上报event
        LCDNativeTrackManager.shareInstance().trackEvent(kLCDNativeTrackEvent_push_arrived, scene: "", categoryForRequest: categoryName! as! String, groupID: groupID as! Int64, categoryName: categoryName as! String, params: nil)

        // 打开新页面
        LCDSceneRouterManager.shareInstance().pushToPageDetail(withGroupID: groupID as! Int64, categoryName: categoryName as! String, rootViewController: getKeyWindow().rootViewController!) { lcdFeedDetailPageConfig in

            lcdFeedDetailPageConfig.adDelegate = self
            lcdFeedDetailPageConfig.delegate = self
        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

extension AppDelegate: LCDAdvertCallBackProtocol {
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

extension AppDelegate: LCDFeedDetailPageDelegate {
    /*! @abstract 视频详情页播放开始的回调 */
//    - (void)lcdVideoDetailPageStartPlayEvent:(LCDEvent *)event controller:(UIViewController *)detailPageVC;
    func lcdVideoDetailPageStartPlay(_ event: LCDEvent, controller detailPageVC: UIViewController) {
        myDebug("视频开始播放")
    }

    /*! @abstract 视频详情页暂停播放的回调 */
//        - void lcdVideoDetailPagePauseEvent: (LCDEvent *) event controller: (UIViewController *) detailPageVC
    func lcdVideoDetailPagePause(_ event: LCDEvent, controller detailPageVC: UIViewController) {
        myDebug("视频暂停播放")
    }

    /*! @abstract 视频详情页继续播放的回调 */
//    - void lcdVideoDetailPageContinueEvent: (LCDEvent *) event controller: (UIViewController *) detailPageVC
    func lcdVideoDetailPageContinue(_ event: LCDEvent, controller detailPageVC: UIViewController) {
        myDebug("视频继续播放")
    }

    /*! @abstract 视频详情页结束播放的回调 */
//    - void lcdVideoDetailPageOverPlayEvent: (LCDEvent *) event controller: (UIViewController *) detailPageVC
    func lcdVideoDetailPageOverPlay(_ event: LCDEvent, controller detailPageVC: UIViewController) {
        myDebug("视频播放结束")
    }

//    - void lcdDocDetailPageReadOverEvent: (LCDEvent *) event controller: (UIViewController *) detailPageVC
    func lcdDocPageDetailReadPrecent(_ event: LCDEvent) {
        myDebug("页面内容读取进度", event.toJSONString())
    }

    /*! @abstract 离开详情页的回调，包含关闭详情页的场景 */
//    - void lcdLeaveDetailPageEvent: (LCDEvent *) event
    func lcdLeaveDetailPageEvent(_ event: LCDEvent) {
        myDebug("页面离开详情页", event.toJSONString())
    }

    /*! @abstract 关闭详情页的回调 */
//    - void lcdCloseDetailPageEvent: (LCDEvent *) event
    func lcdCloseDetailPageEvent(_ event: LCDEvent) {
        myDebug("详情页面关闭了")
    }
}
