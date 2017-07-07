//
//  URCircleButton.swift
//  PasscodeView
//
//  Created by DongSoo Lee on 2017. 7. 7..
//  Copyright © 2017년 PasscodeView. All rights reserved.
//

import UIKit

open class URCicleButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func initView(themeColor: UIColor, needBorder: Bool = true) {
        self.tintColor = themeColor
        self.setTitleColor(self.tintColor, for: UIControlState.normal)

        self.layoutIfNeeded()

        let fontSizeRatio: CGFloat = 23.0 / 95.0
        self.titleLabel!.font = UIFont.boldSystemFont(ofSize: self.bounds.width * fontSizeRatio)

        if needBorder {
            self.layer.cornerRadius = self.bounds.height * 0.5
            self.layer.borderColor = self.tintColor.cgColor
            self.layer.borderWidth = 0.6
            self.layer.masksToBounds = true
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.2)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
