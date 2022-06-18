//
//  AboutUsViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/29/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
//import WebKit

class AboutUsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    let options: [AboutUsOption] = [
        AboutUsOption.init(title: Localization.string(key: MessageKey.Overview), selected: true),
        AboutUsOption.init(title: Localization.string(key: MessageKey.DirectoryNote), selected: false),
        AboutUsOption.init(title: Localization.string(key: MessageKey.OurMission), selected: false),
        AboutUsOption.init(title: Localization.string(key: MessageKey.OurStaff), selected: false)
    ]
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initiliazeViews()
        self.setupCollectionView()
        self.fetchAboutUs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAboutUs() {
        self.showLoader()
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.getAboutUs()
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let jsonObject = result?.json?.first,
                    let json = jsonObject["about_us"] as? NSDictionary {
                        guard let about = About.init(dictionary: json) else {
                            return
                        }
                        
                        Objects.variables.about = about
                    }
                }
                
                self.textView.text = Objects.variables.about?.overview
                self.imageView.image = UIImage(named: "overview")
                self.imageViewHeightConstraint.constant = 175
                
                self.hideLoader()
            }
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func initiliazeViews() {
        if self.tabBarController is GuestTabBarViewController {
            self.buttonClose.isHidden = true
            self.buttonLogout.isHidden = false
        } else {
            self.buttonClose.isHidden = false
            self.buttonLogout.isHidden = true
        }
        
//        self.textView.text = Objects.variables.about?.overview
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.AboutUsCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.AboutUsCollectionViewCell)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.AboutUsCollectionViewCell, for: indexPath) as? AboutUsCollectionViewCell {
            
            let option = options[indexPath.row]
            UIView.performWithoutAnimation {
                cell.buttonOption.isSelected = option.selected
                cell.buttonOption.setTitle(option.title, for: .normal)
                cell.buttonOption.layoutIfNeeded()
            }
            
            cell.buttonOption.tag = indexPath.row
            cell.buttonOption.addTarget(self, action: #selector(buttonOptionTapped(sender:)), for: .touchUpInside)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let option = options[indexPath.row]
        let height = collectionView.frame.height
        if let width = option.title?.width(withConstrainedHeight: height, font: Fonts.montserrat_TextFont_Bold) {
            return CGSize(width: width, height: height)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    @objc func buttonOptionTapped(sender: UIButton) {
        for option in options {
            option.selected = false
        }
        options[sender.tag].selected = true

        self.collectionView.reloadData()
        
        switch sender.tag {
        case 0:
            self.textView.text = Objects.variables.about?.overview
            self.imageView.image = UIImage(named: "overview")
            self.imageViewHeightConstraint.constant = 175
        case 1:
            self.textView.text = Objects.variables.about?.director_note
            self.imageView.image = UIImage(named: "director_note")
            self.imageViewHeightConstraint.constant = 175
        case 2:
            self.textView.text = Objects.variables.about?.our_mission
            self.imageView.image = UIImage(named: "our_mission")
            self.imageViewHeightConstraint.constant = 175
        case 3:
            self.textView.text = Objects.variables.about?.our_staff
            self.imageViewHeightConstraint.constant = 0
        default:
            break
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.MainMenuValidation), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
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

class AboutUsOption {
    var title: String!
    var selected: Bool!
    
    init(title: String, selected: Bool) {
        self.title = title
        self.selected = selected
    }
}
