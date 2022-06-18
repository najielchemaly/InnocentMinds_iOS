//
//  AddActivityViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddAdditionalActivityViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerDelegate {
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewActivityTitle: UIView!
    @IBOutlet weak var textFieldActivityTitle: UITextField!
    @IBOutlet weak var buttonAddImages: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonSelectStudents: UIButton!
    
    var mode: ActionMode = .add
    var activity: Activity = Activity()
    
//    var images: [UIImage] = [UIImage]()
    var selectedStudentIds: [Int] = [Int]()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.isHidden = self.activity.photos?.count == 0 ? true : false
        self.buttonAddImages.isHidden = self.activity.photos?.count == 0 ? false : true
        
        if self.mode == .edit {
            self.textFieldActivityTitle.text = self.activity.title
        }
        
        self.buttonSelectStudents.setTitle(self.selectedStudentIds.count > 0 ? "View selected students" : "Select students", for: .normal)
    }
    
    func initializeViews() {
        self.buttonSave.layer.cornerRadius = self.buttonSave.frame.height/2
        self.buttonAddImages.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonAddImages.imageView?.contentMode = .scaleAspectFit
        self.viewActivityTitle.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonSelectStudents.layer.cornerRadius = Dimensions.cornerRadiusNormal
        
        self.imagePickerDelegate = self
        
        self.labelTitle.text = Localization.string(key: MessageKey.AddAdditionalActivity)
        
        self.collectionView.isHidden = true
        self.viewActivityTitle.isHidden = false
        self.buttonAddImages.isHidden = false
        self.buttonSelectStudents.isHidden = false
        
        self.activity.photos = [Photo]()
        
        if let studentIds = self.activity.student_ids?.split(separator: ",") {
            for studentId in studentIds {
                if let id = Int(studentId) {
                    self.selectedStudentIds.append(id)
                }
            }
        }
        
        if let photos = self.activity.photos {
            for photo in photos {
                if let _image = photo._image {
                    self.activity.photos?.append(Photo(_image: _image))
                } else if let image = photo.image {
                    DispatchQueue.global(qos: .background).async {
                        let imageView = UIImageView()
                        imageView.kf.setImage(with: URL(string: Services.getMediaUrl() + image))
                        if let image = imageView.image {
                            self.activity.photos?.append(Photo(_image: image))
                        }
                    }
                }
            }
        }
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: CellIds.AdditionalImageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.AdditionalImageCollectionViewCell)
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.activity.id = ""
            self.activity.type_id = ActivityType.Additional.rawValue
            self.activity.title = self.textFieldActivityTitle.text
            
            self.activity.student_ids = ""
            for id in self.selectedStudentIds {
                self.activity.student_ids?.append("\(id),")
            }
            self.activity.student_ids?.removeLast()
            
//            self.activity.photos = [Photo]()
//            for image in self.images {
//                let photo = Photo(_image: image)
//                self.activity.photos?.append(photo)
//            }
            
            if let navigationController = self.presentingViewController as? UINavigationController, let additionalActivityVC = navigationController.children.last as? AdditionalActivityViewController {
                if self.mode == .add {
                    additionalActivityVC.additionalActivities.append(activity)
                } else if self.mode == .edit {
                    additionalActivityVC.additionalActivities[additionalActivityVC.editActivityIndex] = activity
                }
                
                additionalActivityVC.shouldAskBeforeLeaving = true
                additionalActivityVC.tableView.reloadData()
                
                Objects.user.additional_activities = additionalActivityVC.additionalActivities
                
                if let userId = Objects.user.id {
                    Activity.saveArray(activities: additionalActivityVC.additionalActivities, key: Activity.key+userId)
                }
            }
            
            self.dismissVC()
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    @IBAction func buttonAddImagesTapped(_ sender: Any) {
        self.handleCameraTap()
    }
    
    @IBAction func buttonSelectStudentsTapped(_ sender: Any) {
        if let selectStudentsVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.SelectStudentsViewController) as? SelectStudentsViewController {
            selectStudentsVC.selectedIds = self.selectedStudentIds
            self.present(selectStudentsVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.AdditionalImageCollectionViewCell, for: indexPath) as? AdditionalImageCollectionViewCell {
            cell.initializeViews()
            
            switch indexPath.row {
            case 0:
                cell.emptyView.isHidden = true
                
                if self.mode == .add {
                    cell.labelImageCount.text = "\(self.activity.photos?.count ?? 0)"
                    if let image = self.activity.photos?.last?._image {
                        cell.imageViewPhoto.image = image
                    }
                } else if self.mode == .edit {
                    cell.labelImageCount.text = "\(self.activity.photos?.count ?? 0)"
                    if let _image = self.activity.photos?.last?._image {
                        cell.imageViewPhoto.image = _image
                    } else if let image = self.activity.photos?.last?.image {
                        cell.imageViewPhoto.kf.setImage(with: URL(string: Services.getMediaUrl() + image))
                    }
                }
            default:
                break
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.handleCameraTap()
        } else {
            if let addPhotoViewController = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AddPhotosViewController) as? AddPhotosViewController {
                if let photos = self.activity.photos {
                    addPhotoViewController.photos = photos
                }
                self.present(addPhotoViewController, animated: true, completion: nil)
            }
        }
    }
    
    let itemSpacing: CGFloat = 5
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width/3)-(itemSpacing/3)

        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing/3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemsCount: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let totalCellWidth = ((collectionViewWidth/3)-(itemSpacing/3))*itemsCount
        let totalSpacingWidth = itemSpacing*(itemsCount-1)
        
        let leftInset = (collectionViewWidth-CGFloat(totalCellWidth+totalSpacingWidth))/itemsCount
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            let photo = Photo(_image: image)
            self.activity.photos?.append(photo)
            
            self.buttonAddImages.isHidden = true
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    func didCancelPickingMedia() {
        
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if self.textFieldActivityTitle.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.TitleEmpty)
            return false
        } else if self.selectedStudentIds.count == 0 {
            errorMessage = Localization.string(key: MessageKey.SelectedStudentsEmpty)
            return false
        } else if self.activity.photos?.count == 0 {
            errorMessage = Localization.string(key: MessageKey.ActivityImagesEmpty)
            return false
        }
        
        return true
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
