//
//  FeedSingleVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/18.
//

import LCDSDK
import UIKit

class FeedSingleVC: UIViewController {
    var type = "__all__"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.type
        // Do any additional setup after loading the view.
        let vc = LCDSingleFeedViewController { [weak self] config in
            guard let self = self else {
                return
            }
            print(self.type)
            config.contentInset = UIEdgeInsets.zero
            config.category = self.type
        }

        vc.view.frame = CGRect(x: 0, y: getNavBarHeight(), width: getScreenWidth(), height: getScreenHeight() - getNavBarHeight())

        addChild(vc)
        view.addSubview(vc.view)
    }
}
