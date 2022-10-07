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
    func emptyDataSetShouldDisplay(_ containerView: UIView) -> Bool

    /// Default is false.
    func emptyDataSetShouldForceToDisplay(_ containerView: UIView) -> Bool

    /// Default is true.
    func emptyDataSetShouldFadeIn(_ containerView: UIView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowScroll(_ containerView: UIView) -> Bool

    /// Default is true.
    func emptyDataSetShouldAllowTouch(_ containerView: UIView) -> Bool
    
    /// Asks the delegate for image view animation permission. Default is false.
    /// Make sure to return a valid CAAnimation object from imageAnimationForEmptyDataSet:
    ///
    /// - Parameter containerView: A UIView subclass object informing the delegate.
    /// - Returns: true if the empty dataset is allowed to animate
    func emptyDataSetShouldAnimateImageView(_ containerView: UIView) -> Bool

    ///
    func emptyDataSet(_ containerView: UIView, didTapView view: UIView)

    ///
    func emptyDataSet(_ containerView: UIView, didTapButton button: UIButton)
    
    /// Tells the delegate that the empty data set will appear.
    ///
    /// - Parameter containerView: A UIView subclass informing the delegate.
    func emptyDataSetWillAppear(_ containerView: UIView)

    /// Tells the delegate that the empty data set did appear.
    ///
    /// - Parameter containerView: A UIView subclass informing the delegate.
    func emptyDataSetDidAppear(_ containerView: UIView)

    /// Tells the delegate that the empty data set will disappear.
    ///
    /// - Parameter containerView: A  UIView informing the delegate.
    func emptyDataSetWillDisappear(_ containerView: UIView)

    /// Tells the delegate that the empty data set did disappear.
    ///
    /// - Parameter containerView: A UIView subclass informing the delegate.
    func emptyDataSetDidDisappear(_ containerView: UIView)
}

/// EmptyDataSetDelegate default implementation so all methods are optional
public extension EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ containerView: UIView) -> Bool {
        return true
    }

    func emptyDataSetShouldForceToDisplay(_ containerView: UIView) -> Bool {
        return false
    }

    func emptyDataSetShouldFadeIn(_ containerView: UIView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowScroll(_ containerView: UIView) -> Bool {
        return false
    }

    func emptyDataSetShouldAllowTouch(_ containerView: UIView) -> Bool {
        return true
    }

    func emptyDataSetShouldAnimateImageView(_ containerView: UIView) -> Bool {
        return true
    }
    
    func emptyDataSet(_ containerView: UIView, didTapView view: UIView) {
        // do nothing
    }

    func emptyDataSet(_ containerView: UIView, didTapButton button: UIButton) {
        // do nothing
    }
    
    func emptyDataSetWillAppear(_ containerView: UIView) {
        
    }
    
    func emptyDataSetDidAppear(_ containerView: UIView) {
        
    }
    
    func emptyDataSetWillDisappear(_ containerView: UIView) {
        
    }
    
    func emptyDataSetDidDisappear(_ containerView: UIView) {
        
    }
}

