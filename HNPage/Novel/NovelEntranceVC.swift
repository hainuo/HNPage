//
//  NovelEntranceVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/18.
//

import UIKit

class NovelEntranceVC: UIViewController {
    var type: BDNovelEntranceKind?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let type = type else {
            return
        }

        // Do any additional setup after loading the view.
        let config = BDNovelEntranceConfig(kind: type)
        config.frame = CGRect(x: 10, y: getNavBarHeight() + 30, width: getScreenWidth(), height: getScreenHeight() - getNavBarHeight() - 200)

        let entrance = BDNovelEntrance(config: config)

//        entrance.backgroundColor = .gray

        let params = BDNovelPublicReadConfigRequestParam()
        params.readConfigType = .recommendFeed
        params.count = 3
        BDNovelPublicConfig.getReadWith(params) { error, recommendFeeds in
            if error != nil {
                print("数据获取失败 错误原因", error!)
                return
            }

            guard let recommendFeeds = recommendFeeds as? [BDNovelPublicReadConfigRecommendFeed] else {
                print("获取到的数据为空")
                return
            }
            print("得到数据", recommendFeeds)

            for item in recommendFeeds {
                print(" === recommendTitle", item.recommendTitle)
                print(" === classifiyNames", item.classifiyNames)
                print(" === bookName", item.bookName)
                print(" === thumbUrl", item.thumbUrl)
                print(" === readConfigType", item.readConfigType)
            }

            config.feed = recommendFeeds.shuffled()
            switch type {
            case .floatBall:
                self.title = "悬浮球"
                config.frame = CGRect(x: 100, y: getNavBarHeight() + 140, width: 50, height: 50)
            case .banner:
                entrance.setBannerType(BDNovelEntranceBannerType.medium)
                self.title = "banner"
            case .kingKong:
                entrance.setKingKongType(BDNovelEntranceKingKongType.typeRoundCorner)
                config.frame = CGRect(x: 0, y: getNavBarHeight() + 40, width: 50, height: 50)
                self.title = "金刚位"
            case .showCase:
                entrance.setShowCaseType(BDNovelEntranceShowCaseColor.color1)
                // TODO: 这里有一个imageview没有内容

//                entrance.setShowCaseType(BDNovelEntranceShowCaseColor.color0)
                self.title = "橱窗"
            case .hotNovel:
                self.title = "热门小说"
                entrance.setHotNovelData(recommendFeeds)
            case .feedSmall:
                self.title = "fedd流小窗"
                entrance.setFeedSmallImageData(recommendFeeds[0])
                entrance.setFeedSmallImageBookBackground(BDNovelEntranceFeedSmallImageType.male)

            case .feedLarge:
                self.title = "feed流大窗"
                entrance.setFeedLargeImageData(recommendFeeds[1])
                entrance.setFeedLargeImageBookBackground(BDNovelEntranceFeedLargeImageType.default)

            @unknown default:
                break
            }

            let string = entrance.pathName()
            print("=== 当前 pathname ", string)
            self.view.addSubview(entrance)
//            entrance.frame = CGRect(x: 0, y: getNavBarHeight() + 10, width: entrance.frame.width, height: entrance.frame.height)

            entrance.entranceShow()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
