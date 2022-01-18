//
//  NovelTVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/13.
//

import UIKit

class NovelTVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = BDNovelPublicConfig.novelViewController(with: BDNovelPublicEnTranceType.channelPage, userInfo: [kBDNovelPageUserInfoFullScreen: true])!
        BDNovelPublicConfig.updatePersonalRecommend(true)
        addChild(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: getScreenWidth(), height: getScreenHeight() - getTabBarheight())
        view.addSubview(vc.view)
    }

    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
