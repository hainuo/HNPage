//
//  MediaTVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/12.
//

import UIKit

class MediaTVC: UITableViewController {
    let cellIdentifier = "MediaTVCCellIdentifier"
    enum infoType: String {
        case chenjinshi = "沉浸式小视频"
        case jiugongge = "宫格 - 两行两列"
        case pubuliu = "宫格 - 瀑布流"
        case kapian24 = "视频卡片(多视频2.4个)"
        case kapianDefault = "视频卡片(多视频1.2个)"
        case dankapian = "视频卡片(单视频)"
        case pushdetail = "push跳转详情页接入"
        case xinxiliu = "信息流支持API能力接入"
        case remengexingtuijianzujian = "热们个性化推荐组件接入"
        case userpage = "个人主页"
    }

    let info: [infoType] = [
        .chenjinshi,
        .jiugongge,
        .pubuliu,
        .kapian24,
        .kapianDefault,
        .dankapian,
        .pushdetail,
        .xinxiliu,
        .remengexingtuijianzujian,
        .userpage
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        if tabBarController != nil {
            tabBarItem = UITabBarItem(title: "视频", image: nil, tag: 0)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return info.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = info[indexPath.row].rawValue
        return cell
    }

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        let item: MediaTVC.infoType = info[indexPath.row]
        print(item)

        switch item {
        case .chenjinshi:
            let vc = ChenjinshiVC()
            navigationController?.pushViewController(vc, animated: true)
        case .jiugongge:
            let vc = JiugonggeVC()
            vc.grideType = .grid
            navigationController?.pushViewController(vc, animated: true)
        case .pubuliu:
            let vc = JiugonggeVC()
            vc.grideType = .waterfall
            navigationController?.pushViewController(vc, animated: true)
        case .kapian24:
            let vc = VideoCard()
            vc.cardType = .type2_4
            navigationController?.pushViewController(vc, animated: true)
        case .kapianDefault:
            let vc = VideoCard()
            vc.cardType = .typeDefault
            navigationController?.pushViewController(vc, animated: true)
        case .dankapian:
            let vc = VideoCardSingle()
            navigationController?.pushViewController(vc, animated: true)
        case .xinxiliu:
            let vc = FeedTVC()
            navigationController?.pushViewController(vc, animated: true)
        case .pushdetail:
            let vc = PushDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .remengexingtuijianzujian:
            let vc = NewsVCViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .userpage:
            let vc = ProfileVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
