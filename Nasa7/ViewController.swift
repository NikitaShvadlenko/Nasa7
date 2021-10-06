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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(PictureCell.self, forCellReuseIdentifier: "\(PictureCell.self)")
        return tableView
       }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
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
    func fetchData() {
        nasaProvider.request(.apod(count: 2)) {[weak self] result in
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
// Зачем?
extension ViewController: PictureCellDelegate {
    func pictureCell(_ pictureCell: PictureCell, needsUpdateWith closure: () -> Void) {
        tableView.beginUpdates()
        closure()
        tableView.endUpdates()
    }
}
