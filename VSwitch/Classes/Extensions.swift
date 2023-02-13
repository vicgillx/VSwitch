//
//  Extensions.swift
//  VSwitch
//
//  Created by karl Kevis on 2023/2/10.
//

import UIKit

public typealias VImage = UIImage
public typealias VStackView = UIStackView
public typealias VView = UIView

protocol VSwitchLayout {
    func layoutSuper(edage:UIEdgeInsets)
}

extension VSwitchLayout where Self:UIView {
    func layoutSuper(edage:UIEdgeInsets) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: edage.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edage.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edage.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -edage.bottom)
        ])
    }
}

extension VView:VSwitchLayout {}

extension UIEdgeInsets {
    init(inset:CGFloat) {
        self.init()
        self.top = inset
        self.bottom = inset
        self.left = inset
        self.right = inset
    }
}

extension VImage {
    func tint(with color:UIColor?) -> UIImage? {
        guard let color = color else { return self }
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return result
    }
}
