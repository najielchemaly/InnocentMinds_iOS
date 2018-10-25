//
//  ClassViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/3/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class ClassViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var labelNurseName: UILabel!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.Logout), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        }
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.redirectToVC(storyboard: nurseStoryboard, storyboardId: StoryboardIds.SearchViewController, type: .present)
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.ClassCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ClassCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.redirectToVC(storyboard: nurseStoryboard, storyboardId: StoryboardIds.NurseStudentViewController, type: .push)
    }
    
    let itemSpacing: CGFloat = 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width/2)-(itemSpacing/2)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.ClassCollectionViewCell, for: indexPath) as? ClassCollectionViewCell {
            
            cell.labelClassName.text = "Class \(indexPath.row+1)-B"
            
            return cell
        }
        
        return UICollectionViewCell()
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
