//
//  ViewController.swift
//  HNPage
//
//  Created by hainuo on 2022/1/11.
//

import UIKit

class ViewController: UIViewController {
    let cellIdentifier = "typeCellIdentifier"
    @IBOutlet var myTV: UITableView!
    let cellItems = [
        TTNRType(name: "短视频", id: 0),
        TTNRType(name: "小说", id: 1),
        TTNRType(name: "小说测试 -  直接进入最后一次阅读历史", id: 2),
        TTNRType(name: "小说测试 -  小说推荐 一本书 ", id: 3),
        TTNRType(name: "小说入口 -  悬浮球", id: 9),
        TTNRType(name: "小说入口 -  banner", id: 10),
        TTNRType(name: "小说入口 -  金刚位", id: 11),
        TTNRType(name: "小说入口 -  橱窗 ", id: 12),
        TTNRType(name: "小说入口 -  热门小说", id: 13),
        TTNRType(name: "小说入口 -  feed小图 ", id: 14),
        TTNRType(name: "小说入口 -  feed大图", id: 15),
        TTNRType(name: "多列信息流", id: 4),
        TTNRType(name: "单列信息流 - 热点", id: 5),
        TTNRType(name: "单列信息流 - 推荐", id: 6),
        TTNRType(name: "单列信息流 - 军事", id: 7),
        TTNRType(name: "单列信息流 - all", id: 8),
    ]

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myTV = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(myTV)
        myTV.tableFooterView = UIView(frame: CGRect.zero)
        myTV.tableHeaderView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
        myTV.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        myTV.dataSource = self
        myTV.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = cellItems[indexPath.row].name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中了\(indexPath)")

        tableView.deselectRow(at: indexPath, animated: true)
        let item = cellItems[indexPath.row]
        print(item)
        if item.id == 0 {
            let vc = MediaTVC()
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 1 {
            let vc = UITabBarController()
            let vc0 = UINavigationController(rootViewController: MediaTVC())
            vc0.tabBarItem = UITabBarItem(title: "视频", image: UIImage(systemName: "play"), tag: 1)
            let vc1 = UINavigationController(rootViewController: NovelTVC())
            vc1.tabBarItem = UITabBarItem(title: "小说", image: UIImage(systemName: "book"), tag: 2)

            vc.viewControllers = [vc0, vc1]
            vc.selectedIndex = 1
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 2 {
            let params = BDNovelPublicReadConfigRequestParam()
            params.readConfigType = .history
            params.count = 1

            BDNovelPublicConfig.getReadWith(params) { [weak self] error, configs in
                guard self != nil else {
                    return
                }

                guard error == nil else {
                    print("错误信息", error as Any)
                    return
                }

                print(" config sssss", configs as Any)
                guard let configs = configs else {
                    return
                }
                guard configs.count > 0 else {
                    return
                }
                BDNovelPublicConfig.openNovelPage(with: configs[0])
            }
        } else if item.id == 3 {
            let params = BDNovelPublicReadConfigRequestParam()
            params.readConfigType = .recommendV1
            params.count = 10

            BDNovelPublicConfig.getReadWith(params) { [weak self] error, configs in
                guard self != nil else {
                    return
                }

                guard error == nil else {
                    print("错误信息", error as Any)
                    return
                }

                print(" config sssss", configs as Any)
                guard let configs = configs else {
                    return
                }
                guard configs.count > 0 else {
                    return
                }
                BDNovelPublicConfig.openNovelPage(with: configs[0])
            }
        } else if item.id == 4 {
            let vc = FeedExploreVC()

            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 5 {
            let vc = FeedSingleVC()
            vc.type = "热点"
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 6 {
            let vc = FeedSingleVC()
            vc.type = "推荐"
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 7 {
            let vc = FeedSingleVC()
            vc.type = "军事"
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 8 {
            let vc = FeedSingleVC()
            vc.type = "__all__"
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 9 {
            let vc = NovelEntranceVC()
            vc.type = .floatBall
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 10 {
            let vc = NovelEntranceVC()
            vc.type = .banner
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 11 {
            let vc = NovelEntranceVC()
            vc.type = .kingKong
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 12 {
            let vc = NovelEntranceVC()
            vc.type = .showCase
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 13 {
            let vc = NovelEntranceVC()
            vc.type = .hotNovel
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 14 {
            let vc = NovelEntranceVC()
            vc.type = .feedSmall
            navigationController?.pushViewController(vc, animated: true)
        } else if item.id == 15 {
            let vc = NovelEntranceVC()
            vc.type = .feedLarge
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
