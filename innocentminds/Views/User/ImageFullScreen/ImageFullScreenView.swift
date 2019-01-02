//
//  ImageFullScreenView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/28/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Photos
import FSPagerView
import FBSDKShareKit

class ImageFullScreenView: UIView, FSPagerViewDelegate, FSPagerViewDataSource, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var buttonInstagram: UIButton!
    @IBOutlet weak var buttonFacebook: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var pagerView: PagerView!
    
    var documentInteractionController: UIDocumentInteractionController!
    var selectedPhoto: Photo = Photo()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func buttonShareTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            let linkToShare = [#imageLiteral(resourceName: "gallery_dummy")]
            
            let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
            
            baseVC.present(activityController, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonFacebookTapped(_ sender: Any) {
        let image = #imageLiteral(resourceName: "gallery_dummy")
        if let sharePhoto = FBSDKSharePhoto(image: image, userGenerated: true) {
            let content = FBSDKSharePhotoContent()
            content.photos = [sharePhoto]
            let shareDialog = FBSDKShareDialog()
            if shareDialog.canShow() {
                shareDialog.shareContent = content
                shareDialog.show()
            }
        }
    }
    
    @IBAction func buttonInstagramTapped(_ sender: Any) {
        if let instagramURL = URL(string: "instagram://app") {
            if (UIApplication.shared.canOpenURL(instagramURL)) {
                let image = #imageLiteral(resourceName: "gallery_dummy")
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        
                        let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                        let shareURL = "instagram://library?LocalIdentifier=" + assetID
                        
                        if let urlForRedirect = URL(string: shareURL) {
                            UIApplication.shared.open(urlForRedirect)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            } else {
                print(" Instagram isn't installed ")
            }
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    func setupPagerView() {
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        self.pagerView.register(UINib.init(nibName: CellIds.ImageFullCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.ImageFullCollectionViewCell)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 1
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.ImageFullCollectionViewCell, at: index) as? ImageFullCollectionViewCell {
            if let _image = self.selectedPhoto._image {
                cell.imageViewFull.image = _image
            } else if let image = self.selectedPhoto.image, !image.isEmpty {
                cell.imageViewFull.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            }
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
}
