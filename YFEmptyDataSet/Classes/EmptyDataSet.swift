//
//  EmptyDataSet.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

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
}

extension UIScrollView: EmptyDataSetInterface {

    public weak var emptyDataSetSource: EmptyDataSetSource? {
        get { return getEmptyDataSetSource() }
        set { setEmptyDataSetSource(newValue) }
    }

    public weak var emptyDataSetDelegate: EmptyDataSetDelegate? {
        get { return getEmptyDataSetDelegate() }
        set { setEmptyDataSetDelegate(newValue) }
    }

    public var isEmptyDataSetVisible: Bool {
        if let reference = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetView) as? WeakReference, let emptyView = reference.object as? EmptyDataSetView {
            return emptyView.isHidden
        }

        return false
    }

    public func reloadEmptyDataSet() {
        layoutEmptyDataSetIfNeeded()
    }
}

