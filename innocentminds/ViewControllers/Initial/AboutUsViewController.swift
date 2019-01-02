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
    
    let options: [AboutUsOption] = [
        AboutUsOption.init(title: "Overview", selected: true),
        AboutUsOption.init(title: "Director's Note", selected: false),
        AboutUsOption.init(title: "Our Mission", selected: false),
        AboutUsOption.init(title: "Our Staff", selected: false)
    ]
    
//    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
//        self.setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initiliazeViews()
        self.setupCollectionView()
//        self.loadWebView(suffix: AboutUs.Overview.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        self.textView.text = Objects.variables.about?.overview
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.AboutUsCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.AboutUsCollectionViewCell)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupWebView() {
//        let webConfiguration = WKWebViewConfiguration()
//        self.webView = WKWebView(frame: self.contentView.bounds, configuration: webConfiguration)
//        self.webView.scrollView.backgroundColor = UIColor.clear
//        self.webView.backgroundColor = UIColor.clear
//        self.webView.isOpaque = false
//        self.webView.uiDelegate = self
//
//        self.contentView.addSubview(self.webView)
    }
    
    func loadWebView(suffix: String) {
//        if let url = URL(string: aboutUrl + suffix) {
//            let request = URLRequest(url: url)
//            self.webView.load(request)
//        }
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
        case 1:
            self.textView.text = Objects.variables.about?.director_note
        case 2:
            self.textView.text = Objects.variables.about?.our_mission
        case 3:
            self.textView.text = Objects.variables.about?.our_staff
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
