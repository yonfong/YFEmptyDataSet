//
//  EmptyDataSetImpl.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

internal extension UIView  {
    
    //MARK: - Data Source Getters
    private var titleLabelString: NSAttributedString? {
        return emptyDataSetSource?.title(forEmptyDataSet: self)
    }
    
    private var detailLabelString: NSAttributedString? {
        return emptyDataSetSource?.description(forEmptyDataSet: self)
    }
    
    private var imageForEmptyDataSet: UIImage? {
        return emptyDataSetSource?.image(forEmptyDataSet: self)
    }
    
    private var imageAnimation: CAAnimation? {
        return emptyDataSetSource?.imageAnimation(forEmptyDataSet: self)
    }
    
    private var imageTintColor: UIColor? {
        return emptyDataSetSource?.imageTintColor(forEmptyDataSet: self)
    }
    
    private func buttonTitle(for state: UIControl.State) -> NSAttributedString? {
        return emptyDataSetSource?.buttonTitle(forEmptyDataSet: self, for: state)
    }
    
    private func buttonImage(for state: UIControl.State) -> UIImage? {
        return emptyDataSetSource?.buttonImage(forEmptyDataSet: self, for: state)
    }
    
    private func buttonBackgroundImage(for state: UIControl.State) -> UIImage? {
        return emptyDataSetSource?.buttonBackgroundImage(forEmptyDataSet: self, for: state)
    }
    
    private var dataSetBackgroundColor: UIColor? {
        return emptyDataSetSource?.backgroundColor(forEmptyDataSet: self)
    }
    
    private var customView: UIView? {
        return emptyDataSetSource?.customView(forEmptyDataSet: self)
    }
    
    private var verticalOffset: CGFloat {
        return emptyDataSetSource?.verticalOffset(forEmptyDataSet: self) ?? 0.0
    }
    
    private func spacing(forEmptyDataSet containerView: UIView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat? {
        return emptyDataSetSource?.spacing(forEmptyDataSet: containerView, after: emptyDataSetElement) ?? EmptyDataSetDefaultSpacing
    }
    
    //MARK: - Delegate Getters & Events (Private)
    
    private var shouldFadeIn: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldFadeIn(self) ?? true
    }
    
    private var shouldDisplay: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldDisplay(self) ?? true
    }
    
    private var shouldBeForcedToDisplay: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldForceToDisplay(self) ?? false
    }
    
    private var isTouchAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowTouch(self) ?? true
    }
    
    private var isScrollAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAllowScroll(self) ?? false
    }
    
    private var isImageViewAnimateAllowed: Bool {
        return emptyDataSetDelegate?.emptyDataSetShouldAnimateImageView(self) ?? true
    }
    
    private func emptyDataSetWillAppear() {
        emptyDataSetDelegate?.emptyDataSetWillAppear(self)
        associatedEmptyDataSetView?.willAppearHandle?()
    }
    
    private func emptyDataSetDidAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear(self)
        associatedEmptyDataSetView?.didAppearHandle?()
    }
    
    private func emptyDataSetWillDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear(self)
        associatedEmptyDataSetView?.willDisappearHandle?()
    }
    
    private func emptyDataSetDidDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear(self)
        associatedEmptyDataSetView?.didDisappearHandle?()
    }

    func isDataEmpty() -> Bool {
        if let proxy = self as? EmptyDataSetProtocol {
            return proxy.isDataEmpty
        } else {
            return true
        }
    }
    
    // MARK: - Layout
    func layoutEmptyDataSetIfNeeded() {        
        guard (emptyDataSetSource != nil || configureEmptyViewClousre != nil) else {
            return
        }
        
        if (shouldDisplay && isDataEmpty()) || shouldBeForcedToDisplay {
            guard let view = self.emptyDataSetView else { return }
            emptyDataSetWillAppear()
            
            view.fadeInOnDisplay = shouldFadeIn

            if view.superview == nil {
                if (self is UITableView || self is UICollectionView) && subviews.count > 0 {
                    insertSubview(view, at: 0)
                } else {
                    addSubview(view)
                }
            }
            
            view.prepareForReuse()
            
            if let customView = self.customView {
                view.customView = customView
            } else {
                view.verticalSpacing = [EmptyDataSetElement: CGFloat]()
                EmptyDataSetElement.allCases.forEach {
                    view.verticalSpacing?[$0] = spacing(forEmptyDataSet: self, after: $0)
                }
                
                view.titleLabel.attributedText = titleLabelString
                view.descriptionLabel.attributedText = detailLabelString
                
                if let imageTintColor = imageTintColor {
                    view.imageView.image = imageForEmptyDataSet?.withRenderingMode(.alwaysTemplate)
                    view.imageView.tintColor = imageTintColor
                } else {
                    view.imageView.image = imageForEmptyDataSet?.withRenderingMode(.alwaysOriginal)
                }
                
                let buttonStates: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
                
                for state in buttonStates {
                    
                    let stateImage = buttonImage(for: state)
                    view.button.setImage(stateImage, for: state)
                    
                    let buttonTitle = buttonTitle(for: state)
                    view.button.setAttributedTitle(buttonTitle, for: state)
                    
                    let stateBgImage = buttonBackgroundImage(for: state)
                    view.button.setBackgroundImage(stateBgImage, for: state)
                }
            }
            
            // Configure offset
            view.verticalOffset = verticalOffset
            
            // Configure the empty dataset view
            view.backgroundColor = dataSetBackgroundColor
            view.isHidden = false
            view.clipsToBounds = true
            
            // Configure empty dataset userInteraction permission
            view.isUserInteractionEnabled = isTouchAllowed
            
            // Configure scroll permission
            (self as? UIScrollView)?.isScrollEnabled = isScrollAllowed

            // Configure image view animation
            if self.isImageViewAnimateAllowed {
                if let animation = imageAnimation {
                    view.imageView.layer.add(animation, forKey: nil)
                }
            } else {
                view.imageView.layer.removeAllAnimations()
            }
            
            
            configureEmptyViewClousre?(view)
            
            view.setupLayout()
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
            
            emptyDataSetDidAppear()
        } else if isEmptyDataSetVisible {
            invalidateEmptyDataSet()
        }
    }
    
    func invalidate() {
        emptyDataSetWillDisappear()
        if associatedEmptyDataSetView != nil {
            associatedEmptyDataSetView?.prepareForReuse()
            associatedEmptyDataSetView?.removeFromSuperview()
            associatedEmptyDataSetView = nil
        }

        (self as? UIScrollView)?.isScrollEnabled = true
        emptyDataSetDidDisappear()
    }

    fileprivate class func swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(aClass, originalSelector), let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector) else {
            return false
        }
        
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        return true
    }
}

// MARK: - UITableView + EmptyDataSetProtocol

extension UITableView: EmptyDataSetProtocol {

    // MARK: - Swizzling
    public func swizzleIfNeeded() {
        Self.swizzleReloadData
        Self.swizzleEndUpdates
    }

    public var isDataEmpty: Bool {
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.tableView(self, numberOfRowsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
    }
    
    // 解决多次调用交换方法
    private static let swizzleReloadData: () = {
        let tableViewOriginalSelector = #selector(UITableView.reloadData)
        let tableViewSwizzledSelector = #selector(UITableView.reloadData_swizzled)
        
        let ret = swizzleMethod(for: UITableView.self, originalSelector: tableViewOriginalSelector, swizzledSelector: tableViewSwizzledSelector)

        if ret {
            debugPrint("table_reloadData_swizzled")
        }
    }()
    
    private static let swizzleEndUpdates: () = {
        let originalSelector = #selector(UITableView.endUpdates)
        let swizzledSelector = #selector(UITableView.endUpdates_swizzled)
        
        let ret = swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
        
        if ret {
            debugPrint("endUpdates_swizzled")
        }
    }()
    

    //MARK: - Method Swizzling
    @objc private func reloadData_swizzled() {
        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc private func endUpdates_swizzled() {
        // Calls the original implementation
        endUpdates_swizzled()
        reloadEmptyDataSet()
    }
}

// MARK: - UICollectionView + EmptyDataSetProtocol

extension UICollectionView: EmptyDataSetProtocol {

    // MARK: - Swizzling
    public func swizzleIfNeeded() {
        Self.swizzleReloadData
        Self.swizzlePerformBatchUpdates
    }

    public var isDataEmpty: Bool {
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.collectionView(self, numberOfItemsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
    }
    
    private static let swizzleReloadData: () = {
        let tableViewOriginalSelector = #selector(UICollectionView.reloadData)
        let tableViewSwizzledSelector = #selector(UICollectionView.reloadData_swizzled)
        
        let ret = swizzleMethod(for: UITableView.self, originalSelector: tableViewOriginalSelector, swizzledSelector: tableViewSwizzledSelector)

        if ret {
            debugPrint("collection_reloadData_swizzled")
        }
    }()
    
    private static let swizzlePerformBatchUpdates: () = {
        let originalSelector = #selector(UICollectionView.performBatchUpdates(_:completion:))
        let swizzledSelector = #selector(UICollectionView.performBatchUpdates_swizzled)
        
        let ret = swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)

        if ret {
            debugPrint("swizzlePerformBatchUpdates")
        }
    }()

    @objc private func reloadData_swizzled() {
        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc private func performBatchUpdates_swizzled() {
        // Calls the original implementation
        performBatchUpdates_swizzled()
        reloadEmptyDataSet()
    }
}


