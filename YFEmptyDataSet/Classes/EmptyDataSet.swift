//
//  EmptyDataSet.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

// MARK: - Swizzling Associated Keys

struct AssociatedKeys {
    static var datasource = "emptyDataSetSource"
    static var delegate = "emptyDataSetDelegate"
    static var emptyDataSetView = "emptyDataSetView"
    static var didSwizzle = "didSwizzle"
}

class WeakReference: NSObject {
    weak var object: AnyObject?

    init(with object: Any?) {
        super.init()
        self.object = object as AnyObject?
    }

    deinit {
        debugPrint("WeakReference -deinit")
        self.object = nil
    }
}

public protocol EmptyDataSetInterface {

    /// The empty datasets delegate
    var emptyDataSetSource: EmptyDataSetSource? { get set }

    /// The empty datasets data source
    var emptyDataSetDelegate: EmptyDataSetDelegate? { get set }

    /// Returns true if the Empty Data Set View is visible
    var isEmptyDataSetVisible: Bool { get }

    /// Reloads the empty dataset content receiver.
    /// Call this method to force all the data to refresh. Calling reloadData() is similar, but this method only refreshes the empty dataset,
    /// instead of all the delegate/datasource calls from your table view or collection view.
    func reloadEmptyDataSet()
    
    func invalidateEmptyDataSet()
}

protocol EmptyDataSetProtocol {
    var isDataEmpty: Bool { get }

    func swizzleIfNeeded()
}

extension EmptyDataSetProtocol {
    var isDataEmpty: Bool {
        return true
    }
    
    func swizzleIfNeeded() {
        debugPrint("swizzleIfNeeded")
    }
}

public extension UIView {
    weak var emptyDataSetView: EmptyDataSetView? {
        get {
            if let emptyView = associatedEmptyDataSetView {
                return emptyView
            } else {
                let view = EmptyDataSetView()

                view.didTapEmptyButtonHandle = {[weak self] emptyView in
                    guard let self = self else { return }
                    
                    self.emptyDataSetDelegate?.emptyDataSet(self, didTapButton: emptyView.button)
                }
                
                view.didTapEmptyViewHandle = {[weak self] emptyView in
                    guard let self = self else { return }
                    
                    self.emptyDataSetDelegate?.emptyDataSet(self, didTapView: emptyView)
                }
                
                associatedEmptyDataSetView = view
                return view
            }
        }
        set {
            associatedEmptyDataSetView = newValue
        }
    }
    
    weak var associatedEmptyDataSetView: EmptyDataSetView? {
        get {
            let reference = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetView) as? WeakReference
            return reference?.object as? EmptyDataSetView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetView, WeakReference(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

extension UIView: EmptyDataSetInterface {
    public var emptyDataSetSource: EmptyDataSetSource? {
        get {
            let reference = objc_getAssociatedObject(self, &AssociatedKeys.datasource) as? WeakReference
            return reference?.object as? EmptyDataSetSource
        }
        set {
            if newValue == nil {
                objc_setAssociatedObject(self, &AssociatedKeys.datasource, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                invalidateEmptyDataSet()
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.datasource, WeakReference(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                (self as? EmptyDataSetProtocol)?.swizzleIfNeeded()
            }
        }
    }

    public var emptyDataSetDelegate: EmptyDataSetDelegate? {
        get {
            let reference = objc_getAssociatedObject(self, &AssociatedKeys.delegate) as? WeakReference
            return reference?.object as? EmptyDataSetDelegate
        }
        set {
            if newValue == nil {
                objc_setAssociatedObject(self, &AssociatedKeys.delegate, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.delegate, WeakReference(with: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    public var isEmptyDataSetVisible: Bool {
        if let emptyView = associatedEmptyDataSetView {
            return emptyView.isHidden
        }

        return false
    }

    public func reloadEmptyDataSet() {
        layoutEmptyDataSetIfNeeded()
    }

    public func invalidateEmptyDataSet() {
        if associatedEmptyDataSetView != nil {
            associatedEmptyDataSetView?.prepareForReuse()
            associatedEmptyDataSetView?.removeFromSuperview()
            associatedEmptyDataSetView = nil
        }

        (self as? UIScrollView)?.isScrollEnabled = true
    }
}



