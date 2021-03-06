//
//  ViewController.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 25.09.2021.
//

import UIKit
import SnapKit
import Moya

class ViewController: UIViewController {
    
    let nasaProvider = MoyaProvider <OpenNasaRoute>()
    var apodModels: [ApodModel] = []
    var isFetchingData = true
    var requestedMoreDatesCount = 1
    
    private var calendar = Calendar.current
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        return dateFormater
    }()
    
    private lazy var currentDateString: String = {
        return dateFormatter.string(from: calendar.date(byAdding: .day, value: -1, to: Date())!)
    }()
    
    private lazy var lastWeekDateString: String = {
        return dateFormatter.string(from: calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!)
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PictureCell.self, forCellReuseIdentifier: "\(PictureCell.self)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData {
            isFetchingData = false
            print (isFetchingData)
        }
    }
    
    private func setupViews() {
        tabBarItem.image = UIImage(systemName: "list.bullet")
        title = "List"
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getNewDates()  {
        var lastWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let currentDate = lastWeekDate
        lastWeekDate = calendar.date(byAdding: .weekOfYear, value: -1 * requestedMoreDatesCount, to: Date())!
        currentDateString = (dateFormatter.string(from: currentDate))
        lastWeekDateString = (dateFormatter.string(from: lastWeekDate))
        requestedMoreDatesCount += 1
    }
    
    func fetchData(completion: () -> Void) {
        nasaProvider.request(.apod(start_date: lastWeekDateString, end_date: currentDateString)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    let apodModels = try response.map([ApodModel].self)
                    self?.apodModels = apodModels
                    self?.tableView.reloadData()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
// MARK: - TableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apodModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PictureCell.self)", for: indexPath) as? PictureCell
        let model = apodModels[indexPath.row]
        cell?.configure(model: model, delegate: self)
        guard let safeCell = cell else {
            fatalError("Can not deque Cell")
        }
        return safeCell
    }
}
// MARK: - PictureCellDelegate
// ???????????
extension ViewController: PictureCellDelegate {
    func pictureCell(_ pictureCell: PictureCell, needsUpdateWith closure: () -> Void) {
        tableView.beginUpdates()
        closure()
        tableView.endUpdates()
    }
}

//MARK: - InfiniteScroll
extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        print(offsetY)
        print(contentHeight)

        if isFetchingData { return }
        if offsetY > contentHeight - scrollView.frame.height + 200 {
            print("should give more now")
            fetchMoreData()

        }
        
        func fetchMoreData() {
            print("is giving more now")
            isFetchingData = true
            getNewDates()
            fetchData {
            isFetchingData = false
        }
    }
}
}


