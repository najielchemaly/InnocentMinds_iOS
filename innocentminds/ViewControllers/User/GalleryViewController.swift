//
//  GalleryViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/30/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedChild: Child = Child()
    var photos: [Photo] = [Photo]()
    
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
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func initializeViews() {
        if let activities = self.selectedChild.activities {
            for activity in activities {
                if let photos = activity.photos {
                    self.photos.append(contentsOf: photos)
                }
            }
        }
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.ImageViewCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ImageViewCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.ImageViewCollectionViewCell, for: indexPath) as? ImageViewCollectionViewCell {
            let photo = self.photos[indexPath.row]
            if let _image = photo._image {
                cell.imageView.image = _image
            } else if let image = photo.image, !image.isEmpty {
                cell.imageView.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageFullScreenView = self.showView(name: Views.ImageFullScreenView) as? ImageFullScreenView {
            imageFullScreenView.selectedPhoto = self.photos[indexPath.row]
            imageFullScreenView.setupPagerView()
        }
    }
    
    let itemSpacing: CGFloat = 20
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
