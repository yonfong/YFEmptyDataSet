//
//  TestViewController.swift
//  EmptyDataSet-Swift
//
//  Created by YZF on 9/11/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import UIKit
import YFEmptyDataSet
import SnapKit

class TestViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {

    let testView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        let navBarButtom = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reload))
        self.navigationItem.rightBarButtonItem = navBarButtom
        
        
        view.addSubview(testView)
        testView.backgroundColor = .red
        
        
        testView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        testView.emptyDataSetSource = self
        testView.emptyDataSetDelegate = self
        testView.reloadEmptyDataSet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
//        return NSAttributedString(string: "lalala")
//    }

    func title(forEmptyDataSet containerView: UIView) -> NSAttributedString? {
        return NSAttributedString(string: "hahaha")
    }
    
    func image(forEmptyDataSet containerView: UIView) -> UIImage? {
        var animatedImages = [UIImage]()
        for i in 0 ... 96 {
            animatedImages.append(UIImage(named: "\(i)")!)
        }
        return UIImage.animatedImage(with: animatedImages, duration: 5)
    }
    
    @objc func reload() {
        testView.reloadEmptyDataSet()
    }
}

