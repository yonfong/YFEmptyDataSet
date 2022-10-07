//
//  EmptyDataSetSource.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

/// The object that acts as the data source of the empty datasets.
/// The data source must adopt the EmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
public protocol EmptyDataSetSource: AnyObject {

    /// Default is nil.
    func title(forEmptyDataSet containerView: UIView) -> NSAttributedString?

    /// Default is nil.
    func description(forEmptyDataSet containerView: UIView) -> NSAttributedString?

    /// Default is nil.
    func image(forEmptyDataSet containerView: UIView) -> UIImage?

    /// Default is nil.
    func imageTintColor(forEmptyDataSet containerView: UIView) -> UIColor?
    
    /// Default is nil.
    func imageAnimation(forEmptyDataSet containerView: UIView) -> CAAnimation?

    /// Default is nil.
    func buttonTitle(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> NSAttributedString?

    /// Default is nil.
    func buttonImage(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func buttonBackgroundImage(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func button(forEmptyDataSet containerView: UIView) -> UIButton?

    /// Default is nil.
    func backgroundColor(forEmptyDataSet containerView: UIView) -> UIColor?
    
    /// Default is nil.
    func customView(forEmptyDataSet containerView: UIView) -> UIView?
    
    /// Asks the data source for a offset for vertical alignment of the content. Default is 0.
    ///
    /// - Parameter containerView: A UIView subclass object informing the delegate.
    /// - Returns: The offset for vertical alignment.
    func verticalOffset(forEmptyDataSet containerView: UIView) -> CGFloat
    
    /// Default is EmptyDataSetDefaultSpacing.
    func spacing(forEmptyDataSet containerView: UIView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat?
}

/// EmptyDataSetSource default implementation so all methods are optional
public extension EmptyDataSetSource {

    func title(forEmptyDataSet containerView: UIView) -> NSAttributedString? {
        return nil
    }

    func description(forEmptyDataSet containerView: UIView) -> NSAttributedString? {
        return nil
    }

    func image(forEmptyDataSet containerView: UIView) -> UIImage? {
        return nil
    }

    func imageTintColor(forEmptyDataSet containerView: UIView) -> UIColor? {
        return nil
    }

    func imageAnimation(forEmptyDataSet containerView: UIView) -> CAAnimation? {
        return nil
    }
    
    func buttonTitle(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }

    func buttonImage(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func buttonBackgroundImage(forEmptyDataSet containerView: UIView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func button(forEmptyDataSet containerView: UIView) -> UIButton? {
        return nil
    }

    func backgroundColor(forEmptyDataSet containerView: UIView) -> UIColor? {
        return nil
    }
    
    func customView(forEmptyDataSet containerView: UIView) -> UIView? {
        return nil
    }
    
    func verticalOffset(forEmptyDataSet containerView: UIView) -> CGFloat {
        return 0
    }

    func spacing(forEmptyDataSet containerView: UIView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat? {
        return EmptyDataSetDefaultSpacing
    }
}

