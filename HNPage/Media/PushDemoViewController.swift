//
//  PushDemoViewController.swift
//  HNPage
//
//  Created by hainuo on 2022/1/17.
//

import UIKit

class PushDemoViewController: UIViewController {
    var groupIdTF: UITextField!
    var categoryNameTF: UITextField!
    var sending = false
    override func viewDidLoad() {
        super.viewDidLoad()
        groupIdTF = UITextField(frame: CGRect(x: 20, y: 100, width: getScreenWidth() - 20 * 2, height: 30))
        groupIdTF.borderStyle = .bezel
        groupIdTF.placeholder = "请输入group_id"
        groupIdTF.text = "7045907789243223304"
        groupIdTF.keyboardType = .numberPad
        view.addSubview(groupIdTF)

        categoryNameTF = UITextField(frame: CGRect(x: 20, y: 140, width: getScreenWidth() - 20 * 2, height: 30))

        categoryNameTF.borderStyle = .bezel
        categoryNameTF.placeholder = "请输入category_name"
        categoryNameTF.text = "__all__"

        view.addSubview(categoryNameTF)

        // Do any additional setup after loading the view.
        let submitButton = UIButton(type: .system)
        submitButton.backgroundColor = .gray
        submitButton.frame = CGRect(x: 20, y: 180, width: getScreenWidth() - 20 * 2, height: 50)
        submitButton.setTitle("发送本地push", for: .normal)
        submitButton.setTitleColor(.label, for: .normal)
        submitButton.addTarget(self, action: #selector(sendPushNotification), for: .touchUpInside)
        view.addSubview(submitButton)
    }

    @objc func sendPushNotification() {
        if sending {
            return
        }

        guard let group_id = Int64(groupIdTF.text!), group_id > 0 else {
            XHProgressHUD.showError("请输入正确的group_id")
            return
        }

        guard let category_name = categoryNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), category_name.count > 0 else {
            XHProgressHUD.showError("请输入正确的category_name")
            return
        }

        sending = true

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "push跳转详情页title"
        notificationContent.body = "我是一条测试消息，👉点我跳转详情页"
        notificationContent.userInfo = [
            "group_id": group_id,
            "category_name": category_name
        ]
        print("发送消息 ----- ")
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "HNPage.UserNotiTest", content: notificationContent, trigger: triger)

        UNUserNotificationCenter.current().add(notificationRequest) { [weak self] error in
            self?.sending = false

            print("发送消息 --结束--- ")
            guard let error = error else {
                return
            }
            print(error)
        }
    }
}
