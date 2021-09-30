//
//  ViewController.swift
//  AbsolutelyNewNasa
//
//  Created by Nikita Shvad on 25.09.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(PictureCell.self, forCellReuseIdentifier: "PictureCell")
        return tableView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
}
//MARK: - TableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell")
        guard let safeCell = cell else {
            fatalError("Can not deque Cell")
        }
        return safeCell
    }
}

