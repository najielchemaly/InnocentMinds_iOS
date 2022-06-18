//
//  BaseViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol ImagePickerDelegate {
    func didFinishPickingMedia(data: UIImage?)
    func didCancelPickingMedia()
}

class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerDelegate: ImagePickerDelegate!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        swipe.direction = .down
//        self.view.addGestureRecognizer(swipe)
        
        self.view.addTapGestureToHideKeyboard()
        
        if hasToolBar() {
//            self.setupToolBarView()
        }
        
        self.imagePickerController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVC = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleCameraTap(sender: UIButton? = nil) {
        let optionActionSheet = UIAlertController(title: Localization.string(key: MessageKey.SelectSource), message: nil, preferredStyle: .actionSheet)
        optionActionSheet.addAction(UIAlertAction(title: Localization.string(key: MessageKey.Camera), style: .default, handler: openCamera))
        optionActionSheet.addAction(UIAlertAction(title: Localization.string(key: MessageKey.Library), style: .default, handler: openPhotoLibrary))
        optionActionSheet.addAction(UIAlertAction(title: Localization.string(key: MessageKey.Cancel), style: .cancel, handler: nil))
        
        present(optionActionSheet, animated: true, completion: nil)
    }
    
    func openCamera(action: UIAlertAction) {
        self.imagePickerController.sourceType = .camera
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(action: UIAlertAction) {
        self.imagePickerController.sourceType = .photoLibrary
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickedImage: UIImage? = nil
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = image
        }
        
        self.imagePickerDelegate.didFinishPickingMedia(data: pickedImage)
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDelegate.didCancelPickingMedia()
        
        dismiss(animated: true, completion: nil)
    }
    
    func hasToolBar() -> Bool {        
        return false
    }
    
    func saveUserInUserDefaults() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Objects.user)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "user")
        userDefaults.set(true, forKey: "isUserLoggedIn")
        userDefaults.synchronize()
    }
    
    func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func buttonGetDirectionsTapped(sender: UIButton) {
        let location = ""
        let coordinates = location.split{$0 == ","}.map(String.init)
        if let latitude = coordinates.first, let longitude = coordinates.last {
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
                let urlString = "comgooglemaps://?ll=\(latitude),\(longitude)"
                if let url = URL(string: urlString) {
                    openURL(url: url)
                }
            }
            else {
                let urlString = "http://maps.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)"
                if let url = URL(string: urlString) {
                    openURL(url: url)
                }
            }
        }
    }
    
    @objc func logout() {
        self.showLoader()
        
        let userId = Objects.user.id ?? "0"
        DispatchQueue.global(qos: .background).async {
            _ = appDelegate.services.logout(id: userId)
            
            DispatchQueue.main.async {
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "user")
                userDefaults.removeObject(forKey: "isUserLoggedIn")
                userDefaults.synchronize()
                
                Objects.user = User()
                
                appDelegate.unregisterFromRemoteNotifications()
                
                if let window = appDelegate.window {
                    if let mainNavigationBarController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.MainNavigationController) as? UINavigationController  {
                        window.rootViewController = mainNavigationBarController
                        
                        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
                    }
                }
                
                self.hideLoader()
            }
        }
    }
    
    func showLoader(message: String? = nil, type: NVActivityIndicatorType? = .ballScaleMultiple,
                    color: UIColor? = nil , textColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        let activityData = ActivityData(message: message, type: type, color: color, backgroundColor: backgroundColor, textColor: textColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        self.dismissKeyboard()
    }
    
    func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func showToast(message: String) {
        let labelMessage = UILabel(frame: CGRect(x: 0, y: 0, width: message.width(withConstrainedHeight: 30, font: Fonts.montserrat_TextFont_Bold), height: 30))
        labelMessage.center = self.view.center
        labelMessage.frame.origin.y = self.view.frame.height-50
        labelMessage.layer.cornerRadius = labelMessage.frame.height/2
        labelMessage.layer.masksToBounds = true
        labelMessage.backgroundColor = Colors.white
        labelMessage.textColor = Colors.textDark
        labelMessage.textAlignment = .center
        labelMessage.text = message
        
        labelMessage.alpha = 0
        self.view.addSubview(labelMessage)
        
        UIView.animate(withDuration: 0.8, animations: {
            labelMessage.alpha = 1
        }, completion: { success in
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
                UIView.animate(withDuration: 0.5, animations: {
                    labelMessage.alpha = 0
                })
            })
        })
    }
    
    var customView = UIView()
    func showView(name: String, duration: Double = 0.3, fromWindow: Bool = true) -> UIView {
        let view = Bundle.main.loadNibNamed(name, owner: self.view, options: nil)
        if let alertView = view?.first as? UIView {
            customView = alertView
            customView.frame = self.view.bounds
            
            customView.alpha = 0
            
            if fromWindow {
                appDelegate.window?.addSubview(customView)
            } else {
                self.view.addSubview(customView)
            }
            
            UIView.animate(withDuration: duration, animations: {
                self.customView.alpha = 1
            })
            
            UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        }

        customView.addTapGestureToHideKeyboard()
        
        return customView
    }
    
    @objc func hideView() {
        self.customView.hide(remove: true)
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    func setNotificationBadgeNumber(label: UILabel) {
        if let notificationNumber = UserDefaults.standard.value(forKey: "notificationNumber") as? String {
            label.text = notificationNumber
            if notificationNumber.isEmpty || notificationNumber == "0" {
                label.isHidden = true
            } else {
                label.isHidden = false
            }
        } else {
            label.text = nil
            label.isHidden = true
        }
    }
    
    func showAlertView(title: String = "Innocent Minds", message: String = "", buttonOkTitle: String = Localization.string(key: MessageKey.Ok), buttonCancelTitle: String = "", dismiss: Bool = false, logout: Bool = false, isError: Bool = false) {
        if let alertView = self.showView(name: Views.AlertView) as? AlertView {
            alertView.initializeViews()
            
            alertView.labelTitle.text = title.isEmpty ? alertView.labelTitle.text! : title
            alertView.labelDescription.text = message.isEmpty ? alertView.labelDescription.text! : message
            
            alertView.buttonOk.setTitle(buttonOkTitle, for: .normal)
            alertView.buttonCancel.setTitle(buttonCancelTitle, for: .normal)
            
            if buttonCancelTitle.isEmpty {
                alertView.buttonCancel.removeFromSuperview()
                alertView.stackViewWidthConstraint.constant = alertView.stackViewWidthConstraint.constant/2
            } else {
                alertView.buttonCancel.addTarget(self, action: #selector(self.hideView), for: .touchUpInside)
            }
            
            if dismiss {
                alertView.buttonOk.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
            } else if !logout {
                alertView.buttonOk.addTarget(self, action: #selector(self.hideView), for: .touchUpInside)
            }
            
            alertView.imageIcon.image = isError ? nil : #imageLiteral(resourceName: "alert_message_icon")
            alertView.labelTitleTopConstraint.constant = isError ? 20 : 40
            
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
    
    func updateNotificationBadge() {
        let userDefaults = UserDefaults.standard
        if let notificationNumber = userDefaults.value(forKey: "notificationNumber") as? String {
            if let notificationBadge = Int(notificationNumber) {
                userDefaults.set(String(describing: notificationBadge + 1), forKey: "notificationNumber")
            }
        } else {
            userDefaults.set(String(describing: "1"), forKey: "notificationNumber")
        }
        userDefaults.synchronize()
    }
    
    func getWeekNumberOfMonth(_ date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfMonth, from: date)
    }
    
    func getNumberOfWeeksInMonth(_ date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let weekRange = calendar.range(of: .weekday,
                                       in: .month,
                                       for: date)
        return weekRange?.count ?? 0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
