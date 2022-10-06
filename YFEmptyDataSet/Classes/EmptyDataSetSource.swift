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
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// Default is nil.
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?

    /// Default is nil.
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?

    /// Default is nil.
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?
    
    /// Asks the data source for the image animation of the dataset.
    ///
    /// - Parameter scrollView: A scrollView subclass object informing the delegate.
    /// - Returns: image animation
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation?

    /// Default is nil.
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?

    /// Default is nil.
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?

    /// Default is nil.
    func button(forEmptyDataSet scrollView: UIScrollView) -> UIButton?

    /// Default is nil.
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?
    
    /// Default is nil.
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?
    
    /// Asks the data source for a offset for vertical alignment of the content. Default is 0.
    ///
    /// - Parameter scrollView: A scrollView subclass object informing the delegate.
    /// - Returns: The offset for vertical alignment.
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat
    
    /// Default is EmptyDataSetDefaultSpacing.
    func spacing(forEmptyDataSet scrollView: UIScrollView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat?
}

/// EmptyDataSetSource default implementation so all methods are optional
public extension EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return nil
    }

    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }

    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        return nil
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func button(forEmptyDataSet scrollView: UIScrollView) -> UIButton? {
        return nil
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return nil
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 0
    }

    func spacing(forEmptyDataSet scrollView: UIScrollView, after emptyDataSetElement: EmptyDataSetElement) -> CGFloat? {
        return EmptyDataSetDefaultSpacing
    }
}

