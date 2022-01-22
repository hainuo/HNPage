//
//  NovelSearchVC.swift
//  HNPage
//
//  Created by hainuo on 2022/1/20.
//

import Kingfisher
import PYSearch
import UIKit

class NovelSearchResultVC: UIViewController {
    var page = 1
    var limit: UInt = 20
    var searchText = "" {
        didSet {
            title = "\(searchText)的搜索结果"
        }
    }

    // 加载层
    var loadMoreView = UIView()
    // 是否允许上拉加载数据
    var loadMoreEnable = true

    var searchSuggestions: [BDNovelSearchSuggestion] = []
    var resultBookInfos: [BDNovelSearchBookInfo] = []
    var hotSearchWords: [String] = ["雪中悍刀行", "将夜", "剑来", "庆余年"]
    let resultCellIdentifier = "searchResultIdentifier"
    var searchResultListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchResultListView = UITableView(frame: view.bounds, style: .grouped)
        searchResultListView.register(UITableViewCell.self, forCellReuseIdentifier: resultCellIdentifier)
        searchResultListView.delegate = self
        searchResultListView.dataSource = self
        setupInfiniteScrollingView()
        searchResultListView.tableFooterView = loadMoreView
//        searchResultListView.isPagingEnabled = false
        view.addSubview(searchResultListView)
    }

    func setupInfiniteScrollingView() {
        loadMoreView.frame = CGRect(x: 0, y: searchResultListView.contentSize.height, width: searchResultListView.bounds.size.width, height: 60)
        loadMoreView.autoresizingMask = .flexibleWidth
        loadMoreView.backgroundColor = .systemBackground

        let activityViewIndeicator = UIActivityIndicatorView(style: .medium)
        activityViewIndeicator.color = .label
        let indicatorX = view.frame.width / 2 - activityViewIndeicator.frame.width / 2
        let indicatorY = loadMoreView.frame.size.height / 2

        activityViewIndeicator.frame = CGRect(x: indicatorX, y: indicatorY, width: activityViewIndeicator.frame.width, height: activityViewIndeicator.frame.height)

        activityViewIndeicator.startAnimating()
        loadMoreView.addSubview(activityViewIndeicator)
    }

    func loadData() {
        print("当前查询 \(searchText) 当前页码\(page) 是否允许加载\(loadMoreEnable ? "是" : "否")")
        guard searchText.count > 0, page > 0 else {
            return
        }
        loadMoreEnable = false
        let params = BDNovelSearchResultsParams()
        params.query = searchText
        params.offset = 0 + UInt(limit * UInt(page - 1))
        params.limit = UInt(limit)

        BDNovelPublicConfig.searchResults(with: params) { [weak self] bookInfos, error in
            guard let self = self else {
                return
            }
            if let error = error {
                print("出现了错误 ", error)
                return
            }

            guard let bookInfos = bookInfos else {
                print("没有获取到数据")
                return
            }
            self.resultBookInfos += bookInfos

            DispatchQueue.main.async {
                self.searchResultListView.reloadData()
                if bookInfos.count < self.limit {
                    self.loadMoreEnable = false
                } else {
                    self.loadMoreEnable = true
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension NovelSearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultBookInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = { () -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: resultCellIdentifier) else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: resultCellIdentifier)
            }
            return cell
        }()
        cell.clipsToBounds = true
        let item = resultBookInfos[indexPath.row]

        cell.imageView?.image = UIImage(systemName: "video")?.withAlignmentRectInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        cell.imageView?.kf.setImage(with: URL(string: item.thumb_url), completionHandler: { result in
            switch result {
            case .success(let result):
                print(result.image)

                cell.imageView!.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
                cell.imageView!.contentMode = .scaleAspectFit
                cell.imageView!.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                //                DispatchQueue.main.async {
                //                    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                tableView.beginUpdates()
                tableView.endUpdates()
            //                }
            case .failure(let error):
                print(error)
            }
        })

        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = item.book_name
        if let detalLabel = cell.detailTextLabel {
            detalLabel.text = " ab " + item.abstract + " 分类:" + item.category + " 阅读数:" + item.read_count
        } else {
            let detailTextLabel = UILabel(frame: CGRect(x: 90, y: 5, width: cell.frame.width - cell.imageView!.frame.width - 10, height: 30))

            detailTextLabel.text = " 分类:" + item.category + " 阅读数:" + item.read_count
//            " ab " + item.abstract  //故事简介
            cell.contentView.addSubview(detailTextLabel)
        }

        cell.accessoryType = .disclosureIndicator

        if loadMoreEnable, indexPath.row == resultBookInfos.count - 1 {
            page += 1
            loadData()
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension NovelSearchResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath, resultBookInfos[indexPath.row].thumb_url)
        let item = resultBookInfos[indexPath.row]
        BDNovelPublicConfig.openNovelReader(item.item_schema_url)
    }
}

extension NovelSearchResultVC: PYSearchViewControllerDelegate {
//    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectHotSearchAt index: Int, searchText: String!) {
//        print("点击了热门搜索", searchText!)
//    }
//
//    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchHistoryAt index: Int, searchText: String!) {
//        print("点击了历史搜索", searchText!)
//    }
//
//    func searchViewController(_ searchViewController: PYSearchViewController!, didSearchWith searchBar: UISearchBar!, searchText: String!) {
//        print("点击了  searchbar搜索", searchText!)
//    }

    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {
        print("点击了 searchBar 变更了", searchText!)
        let params = BDNovelSearchSuggestionParams()
        params.needDetail = true
        params.query = searchText!

        BDNovelPublicConfig.searchSuggestions(with: params) { suggestions, error in
            if let error = error {
                print("数据出错了", error)
                return
            }
            guard let suggestions = suggestions else {
                print("没有获取到数据")
                return
            }
            self.searchSuggestions = suggestions
            searchViewController.searchSuggestions = []
            for item in suggestions {
                searchViewController.searchSuggestions.append(item.book_detail_info.book_name)
            }
        }
    }

//    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
//        print("点击了搜索建议项目", indexPath!)
//        let item = searchSuggestions[indexPath.row]
//        searchBar.delegate?.searchBar?(searchBar, textDidChange: item.book_detail_info.book_name)
//    }
//
//    func didClickBack(_ searchViewController: PYSearchViewController!) {
//        print("点击了返回按钮")
//        searchViewController.navigationController?.popViewController(animated: true)
//    }
//
//    func didClickCancel(_ searchViewController: PYSearchViewController!) {
//        print("点击了取消按钮")
//    }
}
