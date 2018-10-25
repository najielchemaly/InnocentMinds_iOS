//
//  AddPhotosViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/21/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Kingfisher

class AddPhotosViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var photos: [Photo] = [Photo]()
    var selectedActivityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.buttonConfirm.layer.cornerRadius = self.buttonConfirm.frame.height/2
        self.imagePickerDelegate = self
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.AddPhotosCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.AddPhotosCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.AddPhotosCollectionViewCell, for: indexPath) as? AddPhotosCollectionViewCell {
            cell.initializeViews()
            
            if indexPath.row == self.photos.count {
                cell.emptyView.isHidden = false
                cell.buttonDelete.isHidden = true
            } else {
                cell.emptyView.isHidden = true
                cell.buttonDelete.isHidden = false
                if let image = self.photos[indexPath.row].image, !image.isEmpty {
                    cell.imageViewPhoto.kf.setImage(with: URL(string: Services.getMediaUrl() + image))
                } else if let _image = self.photos[indexPath.row]._image {
                    cell.imageViewPhoto.image = _image
                }
            }
            
            cell.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
            cell.buttonDelete.tag = indexPath.row
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.photos.count {
            self.handleCameraTap()
        }
    }
    
    let itemSpacing: CGFloat = 5
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
    
    @objc func buttonDeleteTapped(sender: UIButton) {
        self.photos.remove(at: sender.tag)
        self.collectionView.reloadData()
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        if let addAdditionalActivityVC = self.presentingViewController as? AddAdditionalActivityViewController {
            addAdditionalActivityVC.activity.photos = self.photos
            addAdditionalActivityVC.collectionView.reloadData()
        } else if let navigationController = self.presentingViewController as? UINavigationController, let additionalActivityVC = navigationController.childViewControllers.last as? AdditionalActivityViewController {
            additionalActivityVC.additionalActivities[self.selectedActivityIndex].photos = self.photos
            additionalActivityVC.tableView.reloadData()
        }
        
        self.dismissVC()
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            let photo = Photo(_image: image)
            self.photos.append(photo)
            self.collectionView.reloadData()
        }
    }
    
    func didCancelPickingMedia() {
        
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
