//
//  DetailViewController.swift
//  EmptyDataSet-Swift
//
//  Created by YZF on 29/6/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import YFEmptyDataSet

class OriginalUsageViewController: UITableViewController, EmptyDataSetSource, EmptyDataSetDelegate {

    var config: Configuration!

    var isLoading = false {
        didSet {
            config.isLoading = isLoading
            tableView.reloadEmptyDataSet()
        }
    }
    
    init(_ application: Application) {
        super.init(nibName: nil, bundle: nil)
        
        self.config = Configuration(application, controller: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(self.description) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.reloadEmptyDataSet()
        configureNavigationBar()
        configureStatusBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }
    
    //MARK: - DZNEmptyDataSetSource
    func title(forEmptyDataSet containerView: UIView) -> NSAttributedString? {
        return config.titleString
    }
    
    func description(forEmptyDataSet containerView: UIView) -> NSAttributedString? {
        return config.detailString
    }
    
    func image(forEmptyDataSet containerView: UIView) -> UIImage? {
        return config.image
    }
    
    func imageAnimation(forEmptyDataSet containerView: UIView) -> CAAnimation? {
        return config.imageAnimation
    }
    
    func buttonTitle(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> NSAttributedString? {
        return config.buttonTitle(state)
    }
 
    func buttonBackgroundImage(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> UIImage? {
        return config.buttonBackgroundImage(state)
    }
    
    func backgroundColor(forEmptyDataSet containerView: UIView) -> UIColor? {
       return config.backgroundColor
    }
    
    func verticalOffset(forEmptyDataSet containerView: UIView) -> CGFloat {
        return config.verticalOffset
    }
    
    func spaceHeight(forEmptyDataSet containerView: UIView) -> CGFloat {
       return config.spaceHeight
    }
    
    //MARK: - DZNEmptyDataSetDelegate Methods
    func emptyDataSetShouldDisplay(_ containerView: UIView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ containerView: UIView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ containerView: UIView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ containerView: UIView) -> Bool {
        return isLoading
    }
    
    func emptyDataSet(_ containerView: UIView, didTapView view: UIView) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isLoading = false
        }
    }
    
    func emptyDataSet(_ scrollView: UIView, didTapButton button: UIButton) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isLoading = false
        }
    }
}

extension OriginalUsageViewController {
    
    // Configuration NavigationBar
    func configureNavigationBar() {
        config.configureNavigationBar()
    }
    
    func configureStatusBar() {
        config.configureStatusBar()
    }
    
}
