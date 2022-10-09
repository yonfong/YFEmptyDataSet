//
//  EmptyDataSetView.swift
//  YFEmptyDataSet
//
//  Created by sky on 2022/10/5.
//

import UIKit

public enum EmptyDataSetElement: CaseIterable {
    case image, title, description, button
}

let EmptyDataSetDefaultSpacing: CGFloat = 10

public class EmptyDataSetView: UIView {

    // MARK: - Internal

    var fadeInOnDisplay = false
    var verticalSpacing: [EmptyDataSetElement: CGFloat]?
    var verticalOffset: CGFloat = 0
    
    var didTapEmptyViewHandle: ((_ emptyDataSetView: EmptyDataSetView) -> Void)?
    var didTapEmptyButtonHandle: ((_ emptyDataSetView: EmptyDataSetView) -> Void)?
    
    var willAppearHandle: (() -> Void)?
    var didAppearHandle: (() -> Void)?
    var willDisappearHandle: (() -> Void)?
    var didDisappearHandle: (() -> Void)?
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(emptyViewTaped))
        addGestureRecognizer(tap)
        return tap
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
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
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Private
    private var canShowImage: Bool {
        return imageView.image != nil
    }

    private var canShowTitle: Bool {
        guard let attributedString = titleLabel.attributedText else { return false }
        return !attributedString.string.isEmpty
    }

    private var canShowDescription: Bool {
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
    
    var customView: UIView? {
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
        
        tapGesture.isEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(contentView)
        
        tapGesture.isEnabled = true
    }

    deinit {
        debugPrint("\(self.description) deinit")
    }
    
    // MARK: - UIView Overrides    
    override public func didMoveToSuperview() {
        guard let superview = superview else { return  }
        
        if superview.frame.size.equalTo(.zero) {
            superview.layoutIfNeeded()
        }
            
        frame = CGRect(x: 0, y: 0, width: superview.bounds.width, height: superview.bounds.height)

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

        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: verticalOffset).isActive = true
        contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0).isActive = true
        
        if let customView = customView {
            if customView.superview != contentView {
                customView.removeFromSuperview()
                contentView.addSubview(customView)
            }

            customView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            customView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            customView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0).isActive = true
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
            stackView.translatesAutoresizingMaskIntoConstraints = false

            if let spacing = verticalSpacing {
                if let space = spacing[.image] { stackView.setCustomSpacing(space, after: imageView) }
                if let space = spacing[.title] { stackView.setCustomSpacing(space, after: titleLabel) }
                if let space = spacing[.description] { stackView.setCustomSpacing(space, after: descriptionLabel) }
                if let space = spacing[.button] { stackView.setCustomSpacing(space, after: button) }
            }

            contentView.addSubview(stackView)
            
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 0).isActive = true
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0).isActive = true
        }
    }

    func prepareForReuse() {
        guard contentView.subviews.count > 0 else { return }
        
        contentView.removeConstraints(contentView.constraints)
        
        titleLabel.text = nil
        titleLabel.frame = .zero

        descriptionLabel.text = nil
        descriptionLabel.frame = .zero

        imageView.image = nil

        // Removes all subviews
        contentView.subviews.forEach({$0.removeFromSuperview()})
    }

    // MARK: - Action Handling
    @objc fileprivate func emptyViewTaped() {
        didTapEmptyViewHandle?(self)
    }
    
    @objc fileprivate func didTapButton() {
        didTapEmptyButtonHandle?(self)
    }
}
