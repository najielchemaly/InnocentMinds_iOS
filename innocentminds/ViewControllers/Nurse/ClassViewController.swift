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
    
    var classes: [Class] = [Class]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.classes.count == 0 {
            if let emptyDataView = self.showView(name: Views.EmptyDataView) as? EmptyDataView {
                emptyDataView.labelTitle.text = Localization.string(key: MessageKey.NoClasses)
                emptyDataView.frame = self.collectionView.frame
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        if let classes = Objects.user.classes {
            self.classes = classes
        }
        
        if let fullname = Objects.user.fullname {
            self.labelNurseName.text = "\(fullname) (nurse)"
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.LogoutValidation), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        }
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        if let searchViewController = nurseStoryboard.instantiateViewController(withIdentifier: StoryboardIds.SearchViewController) as? SearchViewController, let searchNavigationController = nurseStoryboard.instantiateViewController(withIdentifier: StoryboardIds.SearchNavigationController) as? UINavigationController {
            searchViewController.classes = self.classes
            self.present(searchNavigationController, animated: true, completion: nil)
        }
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.ClassCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ClassCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let nurseStudentVC = nurseStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NurseStudentViewController) as? NurseStudentViewController {
            nurseStudentVC.selectedClass = self.classes[indexPath.row]
            self.navigationController?.pushViewController(nurseStudentVC, animated: true)
        }
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
            let classe = self.classes[indexPath.row]
            cell.labelClassName.text = classe.name
            
            if let students = Objects.user.children {
                let filteredStudents = students.filter { $0.class_id == classe.id }
                cell.labelStudentsNumber.text = "\(filteredStudents.count) Student (s)"
            }
            
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
