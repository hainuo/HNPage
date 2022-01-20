//
//  FeedExploreVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/18.
//

import LCDSDK
import UIKit

enum LCSCellContainerVCType {
    case channel
    case single
    case stay
    case tab
}

class FeedExploreVC: UIViewController {
    var containerVCType: LCSCellContainerVCType!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = LCDFeedExploreViewController { [weak self] config in
            guard let self = self else {
                return
            }
            config.delegate = self
//            config.scrollViewDelegate = self;
//            config.adDelegate = self;
            print(config.viewSize)
//            print(self.containerVCType)
            if self.containerVCType == .channel {
                config.contentInset = UIEdgeInsets.zero
            }
        }
        title = "多列表图文信息流"
        addChild(vc)
        vc.view.frame = CGRect(x: 0, y: getNavBarHeight(), width: getScreenWidth(), height: getScreenHeight() - getNavBarHeight())
        view.addSubview(vc.view)
    }

    func myDebug(_ msg: Any...) {
        print("多列表图文信息流", msg)
    }
}

extension FeedExploreVC: LCDFeedExploreViewControllerDelegate {
    func lcdContentRequestFail(_ event: LCDEvent) {
        myDebug(" 内容加载失败！", event.toJSONString())
    }

    func lcdContentRequestSuccess(_ events: [LCDEvent]) {
        myDebug("加载成功 ")
        if events.count > 0 {
            for event in events {
                myDebug(event.toJSONString())
            }
        }
    }

    func feedExploreGo(toDetailPageEvent event: LCDEvent, controller feedExploreViewController: LCDFeedExploreViewController) {
        myDebug(" 点击了详情页 ", event.toJSONString())
    }

    func feedExploreChannelChanged(_ params: [AnyHashable: Any], controller feedExploreViewController: LCDFeedExploreViewController) {
        myDebug(" 切换了频道 ", params)
    }
}
