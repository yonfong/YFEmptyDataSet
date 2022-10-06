//
//  EmptyDataSetView.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit
import SnapKit

public enum EmptyDataSetElement: CaseIterable {
    case image, title, description, button
}

let EmptyDataSetDefaultSpacing: CGFloat = 10

internal class EmptyDataSetView: UIView {

    // MARK: - Internal

    var fadeInOnDisplay = false
    var verticalSpacing: [EmptyDataSetElement: CGFloat]?
    var verticalOffset: CGFloat = 0

    lazy var contentView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()

    // MARK: - Private

    fileprivate var canShowImage: Bool {
        return imageView.image != nil
    }

    fileprivate var canShowTitle: Bool {
        guard let attributedString = titleLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }

    fileprivate var canShowDescription: Bool {
        guard let attributedString = descriptionLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }
    
    private var canShowButton: Bool {
        if let attributedTitle = button.attributedTitle(for: .normal) {
            return attributedTitle.length > 0
        } else if let _ = button.image(for: .normal) {
            return true
        }
        
        return false
    }
    
    internal var customView: UIView? {
        willSet {
            if let customView = customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = customView {
                customView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(contentView)
    }

    deinit {
        debugPrint("\(self.description) deinit")
    }
    
    // MARK: - UIView Overrides

    override func didMoveToWindow() {
        guard let superview = superview else { return }
        frame = superview.bounds

        if fadeInOnDisplay {
            UIView.animate(withDuration: 0.25) {
                self.contentView.alpha = 1
            }
        } else {
            contentView.alpha = 1
        }
    }

    // MARK: - Layout

    func setupLayout() {
        
        prepareForReuse()

        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(verticalOffset)
        }
        
        if let customView = customView {
            if customView.superview != contentView {
                customView.removeFromSuperview()
                contentView.addSubview(customView)
            }
            customView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualTo(0)
                make.top.greaterThanOrEqualTo(0)
            }
        } else {
            var views = [UIView]()
            if canShowImage { views.append(imageView) }
            if canShowTitle { views.append(titleLabel) }
            if canShowDescription { views.append(descriptionLabel) }
            if canShowButton { views.append(button) }

            // skip layout if there is nothing to display
            guard views.count > 0 else { return }

            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = EmptyDataSetDefaultSpacing

            if let spacing = verticalSpacing {
                if let space = spacing[.image] { stackView.setCustomSpacing(space, after: imageView) }
                if let space = spacing[.title] { stackView.setCustomSpacing(space, after: titleLabel) }
                if let space = spacing[.description] { stackView.setCustomSpacing(space, after: descriptionLabel) }
                if let space = spacing[.button] { stackView.setCustomSpacing(space, after: button) }
            }

            contentView.addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualTo(0)
                make.top.greaterThanOrEqualTo(0)
            }
        }
    }

    func prepareForReuse() {
        guard contentView.subviews.count > 0 else { return }

        titleLabel.text = nil
        titleLabel.frame = .zero

        descriptionLabel.text = nil
        descriptionLabel.frame = .zero

        imageView.image = nil

        // Removes all subviews
        contentView.subviews.forEach({$0.removeFromSuperview()})
    }

    // MARK: - Gesture Handling

    fileprivate func didTapView(sender: UIView) {
        print("didTapView: \(sender)")
    }

    fileprivate func didTapButton(sender: UIButton) {
        print("didTapButton: \(self)")
    }
}
