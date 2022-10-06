//
//  File.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

/// The object that acts as the delegate of the empty datasets. Use this delegate for receiving action callbacks.
/// The delegate can adopt the EmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
public protocol EmptyDataSetDelegate: AnyObject {

    /// Default is true.
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool

    /// Default is false.
    func emptyDataSetShouldForceToDisplay(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool
    
    /// Asks the delegate for image view animation permission. Default is false.
    /// Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
    ///
    /// - Parameter scrollView: A scrollView subclass object informing the delegate.
    /// - Returns: true if the empty dataset is allowed to animate
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool

    ///
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView)

    ///
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton)
    
    /// Tells the delegate that the empty data set will appear.
    ///
    /// - Parameter scrollView: A scrollView subclass informing the delegate.
    func emptyDataSetWillAppear(_ scrollView: UIScrollView)

    /// Tells the delegate that the empty data set did appear.
    ///
    /// - Parameter scrollView: A scrollView subclass informing the delegate.
    func emptyDataSetDidAppear(_ scrollView: UIScrollView)

    /// Tells the delegate that the empty data set will disappear.
    ///
    /// - Parameter scrollView: A scrollView subclass informing the delegate.
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView)

    /// Tells the delegate that the empty data set did disappear.
    ///
    /// - Parameter scrollView: A scrollView subclass informing the delegate.
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView)
}

/// EmptyDataSetDelegate default implementation so all methods are optional
public extension EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldForceToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }

    func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        // do nothing
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        // do nothing
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        
    }
    
    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        
    }
    
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        
    }
    
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        
    }
}

