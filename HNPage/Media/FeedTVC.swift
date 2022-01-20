//
//  FeedTVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/17.
//

import LCDSDK
import UIKit

class FeedTVC: UITableViewController {
    var categoryName = "__all__"
    var datas: [LCDNativeDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "信息流API"
        // TODO: 此接口还在处理中，待客服处理
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
//        tableView.register(, forCellReuseIdentifier: <#T##String#>)
        loadData()
    }

    // MARK: 加载数据

    func loadData() {
        if categoryName == "" {
            categoryName = "__all__"
        }

//        let centerFrom = categoryName == "__all__" ? kLCDNativeTrackEnterFrom_click_headline : kLCDNativeTrackEnterFrom_click_category
        // TODO: 需要埋点上报

        LCDFeedNativeLoadManager.loadNativeModels(withCategory: "__all__") { nativeModels, extra, error in
            print(" ==== ", nativeModels as Any)
            print(" ==== ", extra as Any)
            print(" ==== ", error as Any)
        }

        LCDFeedNativeLoadManager.loadNativeModels(withCategory: categoryName) { [weak self] nativeModels, extra, error in
            guard let nativeModels = nativeModels else {
                self?.myDebug("没有获取到数据 ")
                if let error = error {
                    self?.myDebug("错误信息 ", error)
                }

                if let extra = extra {
                    self?.myDebug(" extra ", extra)
                }

                return
            }
            self?.myDebug("得到数据", nativeModels)
            self?.datas = nativeModels
            for item in nativeModels {
                self?.myDebug(item.toJSONString())
            }
            self?.tableView.reloadData()
        }
    }

    func myDebug(_ msg: Any...) {
        print("信息流api ", msg)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         // Configure the cell...

         return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension FeedTVC: LCDAdvertCallBackProtocol {
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

extension FeedTVC: LCDFeedDetailPageDelegate {
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
