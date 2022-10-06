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
    }
    
    private func emptyDataSetDidAppear() {
        emptyDataSetDelegate?.emptyDataSetDidAppear(self)
    }
    
    private func emptyDataSetWillDisappear() {
        emptyDataSetDelegate?.emptyDataSetWillDisappear(self)
    }
    
    private func emptyDataSetDidDisappear() {
        emptyDataSetDelegate?.emptyDataSetDidDisappear(self)
    }

    // MARK: - Layout
    func layoutEmptyDataSetIfNeeded() {
        guard let emptyDataSetSource = emptyDataSetSource else { return }
        
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
                    let stateImage = emptyDataSetSource.buttonImage(forEmptyDataSet: self, for: state)
                    view.button.setImage(stateImage, for: state)
                    
                    let buttonTitle = emptyDataSetSource.buttonTitle(forEmptyDataSet: self, for: state)
                    view.button.setAttributedTitle(buttonTitle, for: state)
                    
                    let stateBgImage = emptyDataSetSource.buttonBackgroundImage(forEmptyDataSet: self, for: state)
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
            
            view.setupLayout()
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
            
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
            
            emptyDataSetDidAppear()
        } else if isEmptyDataSetVisible {
            invalidateEmptyDataSet()
        }
    }

    fileprivate func swizzle(originalSelector: Selector, swizzledSelector: Selector) -> Bool {
        guard responds(to: originalSelector) else { return false }

        guard let originalMethod = class_getInstanceMethod(type(of: self), originalSelector),
            let swizzledMethod = class_getInstanceMethod(type(of: self), swizzledSelector) else { return false }

        let targetedMethod = class_addMethod(type(of: self), originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if targetedMethod {
            class_replaceMethod(type(of: self), swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            return true
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            return true
        }
    }

    // MARK: - Gestures

    @objc private func didTapContentView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        emptyDataSetDelegate?.emptyDataSet(self, didTapView: view)
    }
    
    func isDataEmpty() -> Bool {
        if let proxy = self as? EmptyDataSetProtocol {
            return proxy.isDataEmpty
        } else {
            return true
        }
    }
}

// MARK: - UITableView + EmptyDataSetProtocol

extension UITableView: EmptyDataSetProtocol {

    // MARK: - Swizzling
    func swizzleIfNeeded() {
        guard let bool = didSwizzle, !bool else { return }

        swizzle()
    }
    
    func swizzle() -> Bool {
        var swizzleRet = false

        let newReloadDataSelector = #selector(reloadData_swizzled)
        let originalReloadDataSelector = #selector(UITableView.reloadData)
        didSwizzle = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(endUpdates_swizzled)
        let originalEndUpdatesSelector = #selector(UITableView.endUpdates)
        swizzleRet = swizzleRet &&
            swizzle(originalSelector: originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)

        didSwizzle = swizzleRet
        
        return swizzleRet
    }

    var isDataEmpty: Bool {
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.tableView(self, numberOfRowsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
    }

    @objc func reloadData_swizzled() {
        print("reloadData_swizzled")

        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func endUpdates_swizzled() {
        print("endUpdates_swizzled")

        // Calls the original implementation
        endUpdates_swizzled()
        reloadEmptyDataSet()
    }
}

// MARK: - UICollectionView + EmptyDataSetProtocol

extension UICollectionView: EmptyDataSetProtocol {

    // MARK: - Swizzling
    func swizzleIfNeeded() {
        guard let bool = didSwizzle, !bool else { return }

        swizzle()
    }
    
    func swizzle() -> Bool {
        var swizzleRet = false

        let newReloadDataSelector = #selector(reloadData_swizzled)
        let originalReloadDataSelector = #selector(UICollectionView.reloadData)
        swizzleRet = swizzle(originalSelector: originalReloadDataSelector, swizzledSelector: newReloadDataSelector)

        let newEndUpdatesSelector = #selector(performBatchUpdates_swizzled)
        let originalEndUpdatesSelector = #selector(UICollectionView.performBatchUpdates(_:completion:))
        swizzleRet = swizzleRet &&
            swizzle(originalSelector: originalEndUpdatesSelector, swizzledSelector: newEndUpdatesSelector)

        didSwizzle = swizzleRet
        return swizzleRet
    }

    var isDataEmpty: Bool {
        let sections = dataSource?.numberOfSections?(in: self) ?? 1

        for i in 0..<sections {
            if let items = dataSource?.collectionView(self, numberOfItemsInSection: i), items > 0 {
                return false
            }
        }
        
        return true
    }

    @objc func reloadData_swizzled() {
        // Calls the original implementation
        reloadData_swizzled()
        reloadEmptyDataSet()
    }

    @objc func performBatchUpdates_swizzled() {
        // Calls the original implementation
        performBatchUpdates_swizzled()
        reloadEmptyDataSet()
    }
}


