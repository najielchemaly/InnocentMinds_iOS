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
var defaultBackground: String!
var notificationBadge: Int = 0
var calendarType: String = CalendarType.Event.rawValue
var studentsNotArrived: Bool = false

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
    static let kg_seven_sixteen_names: [String?] = UIFont.fontNames(forFamilyName: "KGSevenSixteen")
    
    static var kg_seven_sixteen_TextFont_Regular: UIFont {
        get {
            if let fontName = Fonts.kg_seven_sixteen_names[0] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
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
    static let DashboardNavigationBarController: String = "DashboardNavigationController"
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
    static let SearchNavigationController: String = "SearchNavigationController"
    static let EventsNavigationController: String = "EventsNavigationController"
    static let EventsViewController: String = "EventsViewController"
    static let EventsDetailsViewController: String = "EventsDetailsViewController"
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
    static let EventsTableViewCell: String = "EventsTableViewCell"
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
    static let EmptyDataView: String = "EmptyDataView"
}

struct MessageKey {
    static let SelectSource: String = "SelectSource"
    static let Library: String = "Library"
    static let Camera: String = "Camera"
    static let Cancel: String = "Cancel"
    static let Reset: String = "Reset"
    static let Done: String = "Done"
    static let Ok: String = "Ok"
    static let Yes: String = "Yes"
    static let Delete: String = "Delete"
    static let FirstNameEmpty: String = "FirstNameEmpty"
    static let LastNameEmpty: String = "LastNameEmpty"
    static let DateOfBirthEmpty: String = "DateOfBirthEmpty"
    static let UsernameEmpty: String = "UsernameEmpty"
    static let PasswordEmpty: String = "PasswordEmpty"
    static let NameEmpty: String = "NameEmpty"
    static let EmailEmpty: String = "EmailEmpty"
    static let EmailNotValid: String = "EmailNotValid"
    static let PhoneEmpty: String = "PhoneEmpty"
    static let PhoneNotValid: String = "PhoneNotValid"
    static let AddressEmpty: String = "AddressEmpty"
    static let InternalServerError: String = "InternalServerError"
    static let Register: String = "Register"
    static let EmailSentPref: String = "EmailSentPref"
    static let EmailSentSuff: String = "EmailSentSuff"
    static let RegisterComplete: String = "RegisterComplete"
    static let TitleEmpty: String = "TitleEmpty"
    static let SelectedStudentsEmpty: String = "SelectedStudentsEmpty"
    static let ActivityImagesEmpty: String = "ActivityImagesEmpty"
    static let SpecifyAllergy: String = "SpecifyAllergy"
    static let SpecifyMedications: String = "SpecifyMedications"
    static let LogoutValidation: String = "LogoutValidation"
    static let Logout: String = "Logout"
    static let MainMenuValidation: String = "MainMenuValidation"
    static let DeleteActivity: String = "DeleteActivity"
    static let Rating: String = "Rating"
    static let NapTime: String = "NapTime"
    static let BathType: String = "BathType"
    static let BathPottyType: String = "BathPottyType"
    static let BathTime: String = "BathTime"
    static let PottyTime: String = "PottyTime"
    static let NoMessage: String = "NoMessage"
    static let NoDashboard: String = "NoDashboard"
    static let NoChildren: String = "NoChildren"
    static let NoNotifications: String = "NoNotifications"
    static let BranchEmpty: String = "BranchEmpty"
    static let InquiryEmpty: String = "InquiryEmpty"
    static let NoClasses: String = "NoClasses"
    static let NoResultFound: String = "NoResultFound"
    static let SubmitStudentArrival: String = "SubmitStudentArrival"
    static let Submit: String = "Submit"
    static let Publish: String = "Publish"
    static let TemperatureRequired: String = "TemperatureRequired"
    static let DeleteTemperature: String = "DeleteTemperature"
    static let Save: String = "Save"
    static let TimeEmpty: String = "TimeEmpty"
    static let TemperatureEmpty: String = "TemperatureEmpty"
    static let CommentEmpty: String = "CommentEmpty"
    static let SendContactUs: String = "SendContactUs"
    static let EditProfile: String = "EditProfile"
    static let EditChildProfile: String = "EditChildProfile"
    static let ParentEmpty: String = "ParentEmpty"
    static let DesiredDateEmpty: String = "DesiredDateEmpty"
    static let HearAboutUsEmpty: String = "HearAboutUsEmpty"
    static let FatherNameEmpty: String = "FatherNameEmpty"
    static let GenderEmpty: String = "GenderEmpty"
    static let PlaceOfBirthEmpty: String = "PlaceOfBirthEmpty"
    static let HomeLanguageEmpty: String = "HomeLanguageEmpty"
    static let DesiredLanguageEmpty: String = "DesiredLanguageEmpty"
    static let TransportationEmpty: String = "TransportationEmpty"
    static let WorkplaceEmpty: String = "WorkplaceEmpty"
    static let BloodTypeEmpty: String = "BloodTypeEmpty"
    static let AllergyEmpty: String = "AllergyEmpty"
    static let RegularMedicationEmpty: String = "RegularMedicationEmpty"
    static let DiseaseEmpty: String = "DiseaseEmpty"
    static let SpecialMedicationConditionsEmpty: String = "SpecialMedicationConditionsEmpty"
    static let SleepHabitEmpty: String = "SleepHabitEmpty"
    static let EatingHabitEmpty: String = "EatingHabitEmpty"
    static let CleanEmpty: String = "CleanEmpty"
    static let CharacterEmpty: String = "CharacterEmpty"
    static let NewPasswordEmpty: String = "NewPasswordEmpty"
    static let PasswordNotMatch: String = "PasswordNotMatch"
    static let ChangePassword: String = "ChangePassword"
    static let NoPayments: String = "NoPayments"
    static let Retry: String = "Retry"
    static let SubmitActivities: String = "SubmitActivities"
    static let ActivitiesSent: String = "ActivitiesSent"
    static let PublishActivities: String = "PublishActivities"
    static let ActivitiesPublished: String = "ActivitiesPublished"
    static let LeaveWithoutSaving: String = "LeaveWithoutSaving"
    static let CancelRegistration: String = "CancelRegistration"
    static let NoStudents: String = "NoStudents"
    static let Event: String = "Events"
    static let Food: String = "Food"
    static let Overview: String = "Overview"
    static let DirectoryNote: String = "DirectoryNote"
    static let OurMission: String = "OurMission"
    static let OurStaff: String = "OurStaff"
    static let NoAdditionalActivities: String = "NoAdditionalActivities"
    static let NoAdditionalActivitiesMessage: String = "NoAdditionalActivitiesMessage"
    static let AddAdditionalActivity: String = "AddAdditionalActivity"
    static let NotYetStudents: String = "NotYetStudents"
    static let Allergy: String = "Allergy"
    static let RegularMedications: String = "RegularMedications"
    static let SelectChild: String = "SelectChild"
    static let SettingLanguage: String = "SettingLanguage"
    static let Breakfast: String = "Breakfast"
    static let Lunch: String = "Lunch"
    static let Nap: String = "Nap"
    static let Bathroom: String = "Bathroom"
    static let PottyTraining: String = "PottyTraining"
    static let CannotAddActivity: String = "CannotAddActivity"
    static let NoEvents: String = "NoEvents"
    static let NoFood: String = "NoFood"
    static let CompleteProfileTitle: String = "CompleteProfileTitle"
    static let CompleteProfile: String = "CompleteProfile"
    static let FilterByDate: String = "FilterByDate"
    static let MissingInfo: String = "MissingInfo"
    static let Pay: String = "Pay"
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

enum ActionMode {
    case add
    case edit
}

enum RegisterMode {
    case request
    case add
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

enum CalendarType: String {
    case Event = "1"
    case Food = "2"
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

class PagerView: FSPagerView {
    
}
