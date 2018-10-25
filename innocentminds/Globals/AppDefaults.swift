//
//  AppDefaults.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

let GMS_APIKEY = ""
let APPLE_LANGUAGE_KEY = "AppleLanguages"
let DEVICE_LANGUAGE_KEY = "AppleLocale"
let FACEBOOK_APP_ID = "1579204765559733"

var currentVC: UIViewController!
var isUserLoggedIn: Bool = false
var isReview: Bool = false
var currentUser: User = User()
var defaultBackground: String!
var notificationBadge: Int = 0

var appDelegate: AppDelegate {
    get {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        return AppDelegate()
    }
}

//var termsUrlString = Services.getBaseUrl() + "/terms"
//var privacyUrlString = Services.getBaseUrl() + "/privacy"

enum AppStoryboard : String {
    case Main
    case Nurse
    case Teacher
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

let mainStoryboard = AppStoryboard.Main.instance
let nurseStoryboard = AppStoryboard.Nurse.instance
let teacherStoryboard = AppStoryboard.Teacher.instance

struct Colors {
    static let blueShadow: UIColor = UIColor(hexString: "#040e23")!
    static let appRed: UIColor = UIColor(hexString: "#e61e2a")!
    static let appBlue: UIColor = UIColor(hexString: "#22b8ec")!
    static let appGreen: UIColor = UIColor(hexString: "#c8d633")!
    static let appOrange: UIColor = UIColor(hexString: "#f9b122")!
    static let appYellow: UIColor = UIColor(hexString: "#f6ea25")!
    static let appPurple: UIColor = UIColor(hexString: "#8c65db")!
    static let appGray: UIColor = UIColor(hexString: "#d0d1ca")!
    static let white: UIColor = UIColor(hexString: "#ffffff")!
    static let unreadNotif: UIColor = UIColor(hexString: "#d4dadd")!
    static let readNotif: UIColor = UIColor(hexString: "#dfe5e8")!
    static let textDark: UIColor = UIColor(hexString: "#686868")!
    static let darkBlue: UIColor = UIColor(hexString: "#167295")!
    static let selectedGreen: UIColor = UIColor(hexString: "#4CC317")!
    static let lightGray: UIColor = UIColor(hexString: "#e9ecf0")!
}

struct Fonts {
    static let gaegu_names: [String?] = UIFont.fontNames(forFamilyName: "Gaegu")
    static let montserrat_names: [String?] = UIFont.fontNames(forFamilyName: "Montserrat")
    
    static var gaegu_TextFont_Regular: UIFont {
        get {
            if let fontName = Fonts.gaegu_names[0] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var gaegu_TextFont_Bold: UIFont {
        get {
            if let fontName = Fonts.gaegu_names[1] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var gaegu_TextFont_Light: UIFont {
        get {
            if let fontName = Fonts.gaegu_names[2] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var montserrat_TextFont_Regular: UIFont {
        get {
            if let fontName = Fonts.montserrat_names[0] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var montserrat_TextFont_Bold: UIFont {
        get {
            if let fontName = Fonts.montserrat_names[1] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
}

struct StoryboardIds {
    static let InitialViewController: String = "InitialViewController"
    static let SigninViewController: String = "SigninViewController"
    static let RegisterChildViewController: String = "RegisterChildViewController"
    static let DashboardViewController: String = "DashboardViewController"
    static let MessageDetailsViewController: String = "MessageDetailsViewController"
    static let EditMyProfileViewController: String = "EditMyProfileViewController"
    static let ChangeMyPasswordViewController: String = "ChangeMyPasswordViewController"
    static let DashboardNavigationBarController: String = "DashboardNavigationBarController"
    static let AboutUsViewController: String = "AboutUsViewController"
    static let ContactUsViewController: String = "ContactUsViewController"
    static let GalleryViewController: String = "GalleryViewController"
    static let GuestTabBarViewController: String = "GuestTabBarViewController"
    static let ClassViewController: String = "ClassViewController"
    static let NurseStudentViewController: String = "NurseStudentViewController"
    static let MainNavigationController: String = "MainNavigationController"
    static let NurseNavigationController: String = "NurseNavigationController"
    static let NurseStudentDetailViewController: String = "NurseStudentDetailViewController"
    static let TeacherStudentViewController: String = "TeacherStudentViewController"
    static let TeacherStudentDetailViewController: String = "TeacherStudentDetailViewController"
    static let AddAdditionalActivityViewController: String = "AddAdditionalActivityViewController"
    static let TeacherNavigationController: String = "TeacherNavigationController"
    static let AddPhotosViewController: String = "AddPhotosViewController"
    static let SelectLanguageViewController: String = "SelectLanguageViewController"
    static let SearchViewController: String = "SearchViewController"
    static let SelectStudentsViewController: String = "SelectStudentsViewController"
    static let PaymentViewController: String = "PaymentViewController"
    static let AdditionalActivityViewController: String = "AdditionalActivityViewController"
    static let EditChildProfileViewController: String = "EditChildProfileViewController"
    static let AddDailyAgendaViewController: String = "AddDailyAgendaViewController"
}

struct CellIds {
    static let DashboardHatTableViewCell: String = "DashboardHatTableViewCell"
    static let DashboardPostTableViewCell: String = "DashboardPostTableViewCell"
    static let ChildTableViewCell: String = "ChildTableViewCell"
    static let NotificationTableViewCell: String = "NotificationTableViewCell"
    static let AddNewMessageTableViewCell: String = "AddNewMessageTableViewCell"
    static let MessageTableViewCell: String = "MessageTableViewCell"
    static let MessageOpponentTableViewCell: String = "MessageOpponentTableViewCell"
    static let MessageMeTableViewCell: String = "MessageMeTableViewCell"
    static let MenuTableViewCell: String = "MenuTableViewCell"
    static let AboutUsCollectionViewCell: String = "AboutUsCollectionViewCell"
    static let PhoneNumberTableViewCell: String = "PhoneNumberTableViewCell"
    static let LocateUsTableViewCell: String = "LocateUsTableViewCell"
    static let SendUsMessageTableViewCell: String = "SendUsMessageTableViewCell"
    static let SendUsMessageDetailTableViewCell: String = "SendUsMessageDetailTableViewCell"
    static let ImageFullCollectionViewCell: String = "ImageFullCollectionViewCell"
    static let ImageViewCollectionViewCell: String = "ImageViewCollectionViewCell"
    static let RegisterChildStep1CollectionViewCell: String = "RegisterChildStep1CollectionViewCell"
    static let RegisterChildStep2CollectionViewCell: String = "RegisterChildStep2CollectionViewCell"
    static let RegisterChildStep3CollectionViewCell: String = "RegisterChildStep3CollectionViewCell"
    static let ClassCollectionViewCell: String = "ClassCollectionViewCell"
    static let NurseStudentTableViewCell: String = "NurseStudentTableViewCell"
    static let TemperatureFooterTableViewCell: String = "TemperatureFooterTableViewCell"
    static let TemperatureTableViewCell: String = "TemperatureTableViewCell"
    static let TeacherStudentTableViewCell: String = "TeacherStudentTableViewCell"
    static let TeacherStudentHeaderTableViewCell: String = "TeacherStudentHeaderTableViewCell"
    static let EmptyActivityTableViewCell: String = "EmptyActivityTableViewCell"
    static let BreakfastTableViewCell: String = "BreakfastTableViewCell"
    static let LunchTableViewCell: String = "LunchTableViewCell"
    static let NapTableViewCell: String = "NapTableViewCell"
    static let BathroomTableViewCell: String = "BathroomTableViewCell"
    static let PottyTrainingTableViewCell: String = "PottyTrainingTableViewCell"
    static let AdditionalImageCollectionViewCell: String = "AdditionalImageCollectionViewCell"
    static let AddActivityPostTableViewCell: String = "AddActivityPostTableViewCell"
    static let AddActivityHeaderTableViewCell: String = "AddActivityHeaderTableViewCell"
    static let SendParentsMessageTableViewCell: String = "SendParentsMessageTableViewCell"
    static let AddPhotosCollectionViewCell: String = "AddPhotosCollectionViewCell"
    static let SearchTableViewCell: String = "SearchTableViewCell"
    static let SelectStudentsTableViewCell: String = "SelectStudentsTableViewCell"
    static let PaymentTableViewCell: String = "PaymentTableViewCell"
    static let PersonalInformationCollectionViewCell: String = "PersonalInformationCollectionViewCell"
    static let SchoolBusCollectionViewCell: String = "SchoolBusCollectionViewCell"
    static let PediatricianCollectionViewCell: String = "PediatricianCollectionViewCell"
    static let MedicalInfoCollectionViewCell: String = "MedicalInfoCollectionViewCell"
    static let DiseaseTableViewCell: String = "DiseaseTableViewCell"
    static let HabitsTableViewCell: String = "HabitsTableViewCell"
    static let EmptyDataTableViewCell: String = "EmptyDataTableViewCell"
}

struct Views {
    static let AlertView: String = "AlertView"
    static let ChangeChildView: String = "ChangeChildView"
    static let MessagesView: String = "MessagesView"
    static let PlusActionView: String = "PlusActionView"
    static let ImageFullScreenView: String = "ImageFullScreenView"
    static let SendUsMessageView: String = "SendUsMessageView"
    static let AddTemperatureView: String = "AddTemperatureView"
    static let SendParentsMessageView: String = "SendParentsMessageView"
    static let DiseaseView: String = "DiseaseView"
}

struct MessageKey {
    static let SelectSource: String = "Select Source"
    static let Library: String = "Library"
    static let Camera: String = "Camera"
    static let Cancel: String = "Cancel"
    static let Done: String = "Done"
    static let Ok: String = "Ok"
    static let Yes: String = "Yes"
    static let Delete: String = "Delete"
    static let FirstNameEmpty: String = "First name field cannot be empty"
    static let LastNameEmpty: String = "Last name field cannot be empty"
    static let DateOfBirthEmpty: String = "Date of birth field cannot be empty"
    static let UsernameEmpty: String = "Username field cannot be empty"
    static let PasswordEmpty: String = "Password field cannot be empty"
    static let NameEmpty: String = "Name field cannot be empty"
    static let EmailEmpty: String = "Email field cannot be empty"
    static let PhoneEmpty: String = "Phone number field cannot be empty"
    static let AddressEmpty: String = "Address field cannot be empty"
    static let InternalServerError: String = "An error has occured, please try again."
    static let Register: String = "Register Child"
    static let EmailSentPref: String = "We've sent you an email to"
    static let EmailSentSuff: String = "with further instructions on how to reset your password."
    static let RegisterComplete: String = "Our team will shortly contact you to schedule an appointment."
    static let TitleEmpty: String = "Title field cannot be empty"
    static let SelectedStudentsEmpty: String = "You should select at least 1 student"
    static let ActivityImagesEmpty: String = "You should add at least 1 image"
    static let Specify: String = "If yes, specify"
    static let Logout: String = "Are you sure you want to logout?"
    static let MainMenu: String = "Are you sure you want to return to main menu?"
    static let DeleteActivity: String = "Are you sure you want to delete this activity?"
    static let Rating: String = "You should set a rating"
    static let NapTime: String = "You should specify the nap time"
    static let BathType: String = "You should specify the bath type"
    static let BathPottyType: String = "You should specify the bath potty type"
    static let BathTime: String = "You should specify the bath time"
    static let PottyTime: String = "You should specify the potty time"
    static let NoMessage: String = "There are no messages yet"
    static let NoDashboard: String = "There are no activities yet for your child"
    static let NoChildren: String = "There are no children yet"
    static let NoNotifications: String = "You do not have notifications yet"
    static let BranchEmpty: String = "Branch field cannot be empty"
    static let InquiryEmpty: String = "Inquiry field cannot be empty"
}

struct Dimensions {
    static let cornerRadiusSmall: CGFloat = 5
    static let cornerRadiusNormal: CGFloat = 10
    static let cornerRadiusMedium: CGFloat = 20
    static let cornerRadiusHigh: CGFloat = 30
}

enum AboutUs: String {
    case Overview = "overview.html"
    case DirectorNote = "directornote.html"
    case OurMission = "ourmission.html"
    case OurStaff = "ourstaff.html"
}

enum MessageType: Int {
    case Notifications = 1
    case Messages = 2
}

enum Keys: String {
    case AccessToken = "TOKEN"
    case AppLanguage = "APP-LANGUAGE"
    case AppVersion = "APP-VERSION"
    case DeviceId = "ID"
}

enum SegueId: String {
    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
}

enum Language: Int {
    case Arabic = 1
    case English = 2
}

enum ActivityMode {
    case add
    case edit
}

enum WebViewComingFrom {
    case none
    case terms
    case privacy
}

enum MessageDetailType: String {
    case User
    case Opponent
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
}

enum UserRole: String {
    case Parent = "1"
    case Teacher = "2"
    case TeacherSupervisor = "3"
    case Nurse = "4"
    case Secretary = "5"
    case Admin = "6"
}

enum ParentType: String {
    case Father = "1"
    case Mother = "2"
}

enum ActivityType: String {
    case Breakfast = "1"
    case Lunch = "2"
    case Nap = "3"
    case Bathroom = "4"
    case PottyTraining = "5"
    case Additional = "6"
    
    var identifier: String {
        return String(describing: self)
    }
}

enum BranchId: String {
    case Bliss = "1"
    case Hazmieh = "2"
    case Sanayeh = "3"
}

func getYears() -> NSMutableArray {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let strDate = formatter.string(from: Date.init())
    if let intDate = Int(strDate) {
        let yearsArray: NSMutableArray = NSMutableArray()
        for i in (1964...intDate).reversed() {
            yearsArray.add(String(format: "%d", i))
        }
        
        return yearsArray
    }
    
    return NSMutableArray()
}

func getYearsFrom(yearString: String) -> String {
    let currentYearString = Calendar.current.component(Calendar.Component.year, from: Date())
    if let year = Int(yearString) {
        let currentYear = Int(currentYearString)
        return String(currentYear-year)
    }
    
    return yearString
}

func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
        return "Last year"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
        return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
        return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "A minute ago"
    }
    
    if let second = components.second, second >= 3 {
        return "Just now"
    }
    
    return "Just now"
    
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

class PagerView: FSPagerView {
    
}
