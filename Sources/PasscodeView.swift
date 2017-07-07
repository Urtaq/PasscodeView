//
//  PasscodeView.swift
//  PasscodeView
//
//  Created by Urtaq on {TODAY}.
//  Copyright © 2017 PasscodeView. All rights reserved.
//

import UIKit

class PasscodeView: UIView {
    enum PasscodeDigitMode: Int {
        case Four = 4
        case Eight = 8
    }

    let MarginHorizontal = 50.0
    let MarginHorizontalPasscodeField = 30.0
    let MarginNumberPad = 10.0

    var container: UIView!

    var defaultPasscode: String = "1111"
    var inputPasscode: String = ""
    var mode: PasscodeDigitMode = .Four
    var themeColor: UIColor = UIColor(hexString: "007AFF")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = UIColor.white

        self.configContainer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        self.configContainer()
    }

    private func configContainer() {

        self.container = UIView()
        self.addSubview(self.container)
        self.container.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraint(NSLayoutConstraint(item: self.container, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.container, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
    }

    func initView(themeColor: UIColor?) {
        if let color = themeColor {
            self.themeColor = color
        }

        self.configTitle()
        self.configPasscodeField()
        self.configNumberPad()
    }

    private var lbTitle: UILabel!
    private func configTitle() {
        let title = "Enter Passcode"
        self.lbTitle = UILabel()
        self.lbTitle.text = title
        self.lbTitle.font = UIFont.systemFont(ofSize: 36)
        self.addSubview(self.lbTitle)

        self.lbTitle.snp.makeConstraints { (m) in
            m.centerX.equalTo(self)
            m.top.equalTo(self).offset(20)
        }
    }

    private var passcodeField: UIView!
    private lazy var passcodes: [UIView] = [UIView]()
    private func configPasscodeField() {
        let digit: Int = self.mode.rawValue

        self.passcodeField = UIView()
        self.addSubview(passcodeField)
        self.passcodeField.snp.makeConstraints { (m) in
            m.left.equalTo(self).offset(MarginHorizontal + MarginHorizontalPasscodeField)
            m.right.equalTo(self).offset(-(MarginHorizontal + MarginHorizontalPasscodeField))
            m.top.equalTo(self.lbTitle.snp.bottom).offset(20)
            m.height.equalTo(24)
        }

        self.passcodeField.layoutIfNeeded()
        let passcodeCellWidth: CGFloat = 20.0
        let passcodeAreaWidth = self.passcodeField.bounds.width - passcodeCellWidth * CGFloat(digit)
        for i in 0 ..< digit {
            let view = UIView()
            view.backgroundColor = .white
            self.passcodeField.addSubview(view)
            view.snp.makeConstraints({ (m) in
                m.centerY.equalTo(self.passcodeField)
                m.left.equalTo(self.passcodeField).offset(passcodeAreaWidth / CGFloat(digit + 1) * CGFloat(i + 1) + passcodeCellWidth * CGFloat(i))
                m.width.height.equalTo(passcodeCellWidth)
            })

            view.layer.cornerRadius = passcodeCellWidth * 0.5
            view.layer.borderColor = self.themeColor.cgColor
            view.layer.borderWidth = 0.6

            self.passcodes.append(view)
        }
    }

    private func configNumberPad() {
        self.layoutIfNeeded()

        let numberPadStrings = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "Delete"]

        let numberPadWidth = self.bounds.width - CGFloat(MarginHorizontal * 2)
        for (index, name) in numberPadStrings.enumerated() {
            if name == "" { continue }
            let i = index + 1
            let button = URCicleButton()
            button.setTitle(name, for: UIControlState.normal)

            self.addSubview(button)

            let positionX = i % 3
            let positionY = floor(Double(i - 1) / 3.0)
            let width = Double(numberPadWidth - CGFloat(MarginNumberPad * 3.0)) / 3.0
            if positionX == 1 {
                button.snp.makeConstraints({ (m) in
                    m.left.equalTo(MarginHorizontal)
                    m.top.equalTo(self.passcodeField.snp.bottom).offset(MarginHorizontal + (width + MarginNumberPad) * positionY)
                    m.width.height.equalTo(width)
                })
            } else if positionX == 2 {
                button.snp.makeConstraints({ (m) in
                    m.centerX.equalTo(self)
                    m.top.equalTo(self.passcodeField.snp.bottom).offset(MarginHorizontal + (width + MarginNumberPad) * positionY)
                    m.width.height.equalTo(width)
                })
            } else {
                button.snp.makeConstraints({ (m) in
                    m.right.equalTo(-MarginHorizontal)
                    m.top.equalTo(self.passcodeField.snp.bottom).offset(MarginHorizontal + (width + MarginNumberPad) * positionY)
                    m.width.height.equalTo(width)
                })
            }

            if name == "Delete" {
                button.initView(themeColor: self.themeColor, needBorder: false)
                button.addTarget(self, action: #selector(tapDelete(_:)), for: UIControlEvents.touchUpInside)
            } else {
                button.initView(themeColor: self.themeColor)
                button.addTarget(self, action: #selector(tapNumberPad(_:)), for: UIControlEvents.touchUpInside)
            }
        }

    }

    open func setPasscode(passcode: String) {
        self.defaultPasscode = passcode
    }

    open func tapNumberPad(_ sender: URCicleButton) {
        self.inputPasscode.append(sender.titleLabel!.text!)

        self.validatePasscode(passcode: self.inputPasscode)
    }

    open func tapDelete(_ sender: URCicleButton) {
        self.inputPasscode.characters.removeLast()

        self.validatePasscode(passcode: self.inputPasscode)
    }

    open func validatePasscode(passcode: String) {
        let passcodeLength = passcode.characters.count

        var themeRed: CGFloat = 0.0
        var themeGreen: CGFloat = 0.0
        var themeBlue: CGFloat = 0.0
        var themeAlpha: CGFloat = 0.0
        _ = self.themeColor.getRed(&themeRed, green: &themeGreen, blue: &themeBlue, alpha: &themeAlpha)
        let passcodeColorRatio: CGFloat = 0.8
        let passcodeColor = UIColor(red: themeRed * passcodeColorRatio, green: themeGreen * passcodeColorRatio, blue: themeBlue * passcodeColorRatio, alpha: themeAlpha)

        for i in 0 ..< self.mode.rawValue {
            let view = self.passcodes[i]
            if i < passcodeLength {
                view.backgroundColor = passcodeColor
            } else {
                view.backgroundColor = .white
            }
        }

        if passcodeLength == 4 {
            if self.defaultPasscode == passcode {
                self.removeFromSuperview()
            } else {
                self.inputPasscode = ""
                self.validatePasscode(passcode: self.inputPasscode)
            }
        }
    }
}
