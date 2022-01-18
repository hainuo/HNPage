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
        TTNRType(name: "小说测试 -  小说推荐", id: 3)
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
        } else if item.id == 1 {
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
        }
    }
}
