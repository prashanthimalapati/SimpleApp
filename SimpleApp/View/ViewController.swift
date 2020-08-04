//
//  ViewController.swift
//  SampleApp
//
//  Created by prashanthi M on 04/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import UIKit
import Foundation
import UIKit

struct demoURL {
    static let strUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}


class ViewController : UIViewController {
    
    var tblView = UITableView()
    var viewModel = ListViewModel()
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblView.addSubview(refreshControl)
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    @objc func refresh(_ sender: Any) {
        getData()
        refreshControl.endRefreshing()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorColor = UIColor.clear
        tblView.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        tblView.allowsSelection = false
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 120
        tblView.register(CustomTableViewCell.self, forCellReuseIdentifier: "ReuseId")
        self.view.addSubview(tblView)
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tblView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tblView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tblView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            ])
        
    }
    
    
    func getData(){
        Apputils.sharedInstance.showLoader()
        viewModel.getDataFromAPI(url: demoURL.strUrl) { (responseData) in
            Apputils.sharedInstance.removeLoader()
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self?.navigationController?.navigationBar.topItem?.title = responseData.title
                self?.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                self?.tblView.reloadData()
            }
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.getNumberOfRowsInSection())
        return viewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseId", for: indexPath) as? CustomTableViewCell
        let items = viewModel.getUserAtIndex(index: indexPath.row)
        cell?.configureCell(withViewModel: items)
        return cell!
    }
    
}



