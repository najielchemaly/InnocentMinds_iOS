//
//  Extensions.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import Foundation
import FSPagerView
import UIKit
import NVActivityIndicatorView

extension UIColor {
    public convenience init?(hexString: String, alpha: CGFloat = 1) {
        assert(hexString[hexString.startIndex] == "#", "Expected hex string of format #RRGGBB")
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    a = alpha
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIView {
    
    func animate(withDuration duration: TimeInterval = 1.0, alpha: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func loadAndSetupXib(fromNibNamed nibName: String) {
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func customizeView(color: UIColor, withRadius: Bool = true) {
        self.backgroundColor = color
        
        if withRadius {
            self.layer.cornerRadius = Dimensions.cornerRadiusNormal
        }
    }
    
    func customizeBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat = 1) {
        let border = CALayer()
        border.backgroundColor = color.withAlphaComponent(alpha).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func isEnabled(enable: Bool) {
        self.isUserInteractionEnabled = enable
        self.alpha = enable ? 1 : 0.7
    }
    
    func hide(remove: Bool = false) {
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { success in
            if remove {
                self.removeFromSuperview()
            }
        })
    }
    
    func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
    func customizeView(width: CGFloat = Dimensions.cornerRadiusNormal) {
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.white.cgColor
        self.layer.cornerRadius = width
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func showError() {
        self.layer.borderColor = Colors.appRed.cgColor
        self.layer.borderWidth = 2
    }
    
    func hideError() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func addTapGestureToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
}

extension UITextView {
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
}

extension UIDatePicker {
    
    func setMaxDate() {
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    }
    
}

extension BaseViewController {
    
    enum NavigationType : String {
        case push = "PUSH"
        case present = "PRESENT"
        case popup = "POPUP"
        case fromBottom = "FROM BOTTOM"
    }
    
    func redirectToVC(storyboard: UIStoryboard? = nil, storyboardId: String, type: NavigationType, animated: Bool = true, title: String? = nil, backTitle: String? = "BACK", delegate: UIPopoverPresentationControllerDelegate? = nil) {
        let storyboard = storyboard ?? self.storyboard
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: storyboardId) {
            switch type {
            case .push:
                destinationVC.navigationItem.backBarButtonItem?.title = backTitle
                destinationVC.navigationItem.title = title
                
                currentVC.navigationController?.pushViewController(destinationVC, animated: animated)
                break
            case .present:
                self.present(destinationVC, animated: animated, completion: nil)
                break
            case .popup:
                destinationVC.modalPresentationStyle = .popover
                let popover = destinationVC.popoverPresentationController
                popover?.permittedArrowDirections = .init(rawValue: 0)
                popover?.sourceRect = view.bounds
                popover?.sourceView = view
                popover?.delegate = delegate
                
                self.present(destinationVC, animated: true, completion: nil)
                break
            case .fromBottom:
                let transition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.push;
                transition.subtype = CATransitionSubtype.fromTop;
                currentVC.navigationController?.view.layer.add(transition, forKey: kCATransition)
                currentVC.navigationController?.pushViewController(destinationVC, animated: false)
                break
            }
        }
    }
    
    func showAlert(title: String = "Innocent Minds", message: String, style: UIAlertController.Style, popVC: Bool = false, dismissVC: Bool = false) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: Localization.string(key: MessageKey.Ok), style: .default, handler: { action in
            if popVC {
                self.popVC()
            } else if dismissVC {
                self.dismissVC()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.customView.endEditing(true)
    }
    
    @objc func popVC(toRoot: Bool = false, fromTop: Bool = false) {
        if toRoot {
            self.navigationController?.popToRootViewController(animated: true)
        } else if fromTop {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            navigationController?.view.layer.add(transition, forKey:kCATransition)
            self.navigationController?.popViewController(animated: false)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissVC() {
        self.hideView()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIButton {
    
    func customizeLayout(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    func setAttributedText(firstText: String, secondText: String, color: UIColor) {
        let firstAttrs = [NSAttributedString.Key.foregroundColor : color]
        let attributedString = NSMutableAttributedString(string: firstText, attributes: firstAttrs)
        let secondAttrs = [NSAttributedString.Key.font : Fonts.montserrat_TextFont_Bold, NSAttributedString.Key.foregroundColor : color]
        let attrString = NSMutableAttributedString(string: secondText, attributes:secondAttrs)
        attributedString.append(attrString)
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setSelected(value: Bool) {
        if value {
            self.backgroundColor = Colors.appBlue
//            self.setTitleColor(Colors.lightGray, for: .normal)
        } else {
//            self.backgroundColor = Colors.lightGray
//            self.setTitleColor(Colors.textDark, for: .normal)
        }
    }
    
    func isSelected() -> Bool {
        if self.backgroundColor == Colors.appBlue {
            return true
        } else {
            return false
        }
    }
    
}

extension UIImageView {
    
    func customizeTint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

//extension UIApplication {
//
//    var statusBarView: UIView? {
//        return value(forKey: "statusBar") as? UIView
//    }
//
//}

extension String {
    
    init?(dictionary: NSDictionary) {
        if dictionary["images"] != nil {
            self = dictionary["images"] as! String
        } else {
            self = ""
        }
    }
    
    public static func modelsFromDictionaryArray(array:NSArray) -> [String] {
        var models:[String] = []
        for item in array {
            if let someItem = item as? String {
                models.append(someItem)
            } else {
                models.append(String(dictionary: item as! NSDictionary)!)
            }
        }
        return models
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func safeAddingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String? {
        let allowedCharacters = CharacterSet(bitmapRepresentation: allowedCharacters.bitmapRepresentation)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        return self.count >= 8
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Optional where Wrapped == String {
    
    func isNullOrEmpty() -> Bool {
        if self == nil || self == "" {
            return true
        }
        
        return false
    }
    
}

extension FSPageControl {
    
    func hidesForSinglePage(hide: Bool) {
        if hide && self.numberOfPages == 1 {
            self.isHidden = true
        }
    }
    
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return self.pngData() }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImage().jpegData(compressionQuality: quality.rawValue)
    }
    
}

extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getMonthFrom(number: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.monthSymbols[number-1]
        return strMonth
    }
    
    func getWeekNumber() -> Int {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfMonth, from: Date())
        return weekOfYear-1
    }
    
}

protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.5) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Bluring {}

extension UIStackView {
    func setSelectedStar(index: Int) {
        for view in self.subviews {
            if let button = view as? UIButton {
                button.isSelected = button.tag <= index
            }
        }
    }
}

protocol JSONable {}
extension JSONable {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let childTemperatures = child.value as? Array<ChildTemperature> {
                    var temperatures = [NSDictionary]()
                    for childTemperature in childTemperatures {
                        temperatures.append(childTemperature.toDict() as NSDictionary)
                    }
                    
                    dict[key] = temperatures
                } else if let childActivities = child.value as? Array<Activity> {
                    var activities = [NSDictionary]()
                    for childActivity in childActivities {
                        activities.append(childActivity.toDict() as NSDictionary)
                    }
                    
                    dict[key] = activities
                } else if let activityPhotos = child.value as? Array<Photo> {
                    var photos = [NSDictionary]()
                    for activityPhoto in activityPhotos {
                        photos.append(activityPhoto.toDict() as NSDictionary)
                    }
                    
                    dict[key] = photos
                } else if child.value is UIImage {
                    // Do nothing
                } else {
                    dict[key] = child.value
                }
            }
        }
        return dict
    }
}

extension UIWindow {
    func showLoader(message: String? = nil, type: NVActivityIndicatorType? = .ballScaleMultiple,
                    color: UIColor? = nil , textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        let activityData = ActivityData(message: message, type: type, color: color, backgroundColor: backgroundColor, textColor: textColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)        
    }
}
