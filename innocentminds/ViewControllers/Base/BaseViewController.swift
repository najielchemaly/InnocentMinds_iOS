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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
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
    
    func handleCameraTap(sender: UIButton? = nil) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var pickedImage: UIImage? = nil
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
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
        
        let userId = currentUser.id
        DispatchQueue.global(qos: .background).async {
            _ = appDelegate.services.logout(id: String(describing: userId))
            
            DispatchQueue.main.async {
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "user")
                userDefaults.removeObject(forKey: "isUserLoggedIn")
                userDefaults.synchronize()
                
                if let window = appDelegate.window {
                    if let mainNavigationBarController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.MainNavigationController) as? UINavigationController  {
                        window.rootViewController = mainNavigationBarController
                    }
                }
                
                self.hideLoader()
            }
        }
    }
    
    func showLoader(message: String? = nil, type: NVActivityIndicatorType? = .ballScaleMultiple,
                    color: UIColor? = nil , textColor: UIColor? = nil) {
        let activityData = ActivityData(message: message, type: type, color: color, textColor: textColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        self.dismissKeyboard()
    }
    
    func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
    func showView(name: String, duration: Double = 0.3) -> UIView {
        let view = Bundle.main.loadNibNamed(name, owner: self.view, options: nil)
        if let alertView = view?.first as? UIView {
            customView = alertView
            customView.frame = self.view.bounds
            
            customView.alpha = 0
            self.view.addSubview(customView)
//            appDelegate.window?.addSubview(customView)
            
            UIView.animate(withDuration: duration, animations: {
                self.customView.alpha = 1
            })
            
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        }
        
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
    
    func showAlertView(title: String = "Innocent Minds", message: String = "", buttonOkTitle: String = "", buttonCancelTitle: String = "", dismiss: Bool = false, logout: Bool = false) {
        if let alertView = self.showView(name: Views.AlertView) as? AlertView {
            alertView.initializeViews()
            
            alertView.labelTitle.text = title.isEmpty ? alertView.labelTitle.text! : title
            alertView.labelDescription.text = message.isEmpty ? alertView.labelDescription.text! : message
            
            if buttonCancelTitle.isEmpty {
                alertView.buttonCancel.removeFromSuperview()
                alertView.stackViewWidthConstraint.constant = alertView.stackViewWidthConstraint.constant/2
                
                if dismiss {
                    alertView.buttonOk.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
                } else if !logout {
                    alertView.buttonOk.addTarget(self, action: #selector(self.hideView), for: .touchUpInside)
                }
            } else {
                alertView.buttonCancel.addTarget(self, action: #selector(self.hideView), for: .touchUpInside)
            }
            
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
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
