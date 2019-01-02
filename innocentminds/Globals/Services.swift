//
//  Services.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ServiceName {
    
    static let registerChild = "/registerChild/"
    static let login = "/login/"
    static let loginToken = "/loginToken/"
    static let changePassword = "/changePassword/"
    static let editProfile = "/editProfile/"
    static let editChild = "/editChild/"
    static let logout = "/logout/"
    static let getText = "/getText/"
    static let forgotPassword = "/forgotPassword/"
    static let updateToken = "/updateToken/"
    static let getNotifications = "/getNotifications/"
    static let updateNotification = "/updateNotification/"
    static let getStatementOfAccount = "/getStatementOfAccount/"
    static let sendMessage = "/sendMessage/"
    static let sendContactUs = "/sendContactUs/"
    static let updateStudentStatus = "/updateStudentStatus/"
    static let addTemperature = "/addTemperature/"
    static let addActivity = "/addActivity/"
    static let publishActivity = "/publishActivity/"
    static let deleteActivity = "/deleteActivity/"
    static let getActivities = "/getActivities/"
    static let uploadImage = "/uploadImage/"
    static let getGlobalVariables = "/getGlobalVariables/"
    static let getParentChildren = "/getParentChildren/"
    
}

enum ResponseStatus: Int {
    
    case SUCCESS = 1
    case FAILURE = 0
    case CONNECTION_TIMEOUT = -1
    case UNAUTHORIZED = -2
    
}

enum ResponseMessage: String {
    
    case SERVER_UNREACHABLE = "An error has occured, please try again."
    case CONNECTION_TIMEOUT = "Check your internet connection."
    
}

class ResponseData {
    
    var status: Int = ResponseStatus.SUCCESS.rawValue
    var message: String = String()
    var json: [NSDictionary]? = [NSDictionary]()
    var jsonObject: JSON? = JSON((Any).self)
    
}

class Services {
    
    private static var _AccessToken: String = ""
    var ACCESS_TOKEN: String {
        get {
            if let token = UserDefaults.standard.string(forKey: Keys.AccessToken.rawValue) {
                Services._AccessToken = token
            }
            
            return Services._AccessToken
        }
    }
    
    static let ConfigUrl = "http://localhost:5000/Api"
//    static let ConfigUrl = "http://najielchemaly-001-site1.itempurl.com/Api"
//    static let ConfigUrl = "http://api.innocentmindsapp.com/Api"
    
    private static var _BaseUrl: String = ""
    var BaseUrl: String {
        get {
            return Services._BaseUrl
        }
        set {
            Services._BaseUrl = newValue
        }
    }
    
    private static var _MediaUrl: String = ""
    var MediaUrl: String {
        get {
            return Services._MediaUrl
        }
        set {
            Services._MediaUrl = newValue
        }
    }
    
    func getConfig() -> ResponseData? {
        return makeHttpRequest(method: .post, serviceName: ServiceName.getGlobalVariables, isConfig: true)
    }
    
    func registerChild(user: User, roleId: String, isRequest: Bool) -> ResponseData? {
        
        var parameters = [String : Any]()
        if let child = user.children?.first {
            parameters = [
                "child_firstname": child.firstname!,
                "child_lastname": child.lastname!,
                "child_dob": child.date_of_birth!,
                "branch": child.branch_id!,
                "desired_date": child.desired_date_of_entry!,
                "fullname": user.fullname!,
                "phone": user.phone!,
                "email": user.email!,
                "address": user.address!,
                "hear_about_us": child.hear_about_us_id!,
                "parent_type": user.parent_type!,
                "is_request": isRequest,
                "role_id": roleId
            ]
        }
        
        let serviceName = ServiceName.registerChild
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func login(email: String, password: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        let serviceName = ServiceName.login
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func login(accessToken: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "access_token": accessToken
        ]
        
        let serviceName = ServiceName.loginToken
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func changePassword(id: String, oldPassword: String, newPassword: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": id,
            "old_password": oldPassword,
            "new_password": newPassword
        ]
        
        let serviceName = ServiceName.changePassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func editProfile(id: String, fullname: String, phoneNumber: String, email: String, address: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "fullname": fullname,
            "phone": phoneNumber,
            "email": email,
            "address": address
        ]
        
        let serviceName = ServiceName.editProfile
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func editChild(id: String, child: Child) -> ResponseData? {
        let parameters: Parameters = child.toDict()
        
        let serviceName = ServiceName.editChild
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func logout(id: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": id
        ]
        
        let serviceName = ServiceName.logout
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getText(id: String, query: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": id,
            "query": query
        ]
        
        let serviceName = ServiceName.getText
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func forgotPassword(email: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email
        ]
        
        let serviceName = ServiceName.forgotPassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func updateToken(id: String, token: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": id,
            "firebase_token": token
        ]
        
        let serviceName = ServiceName.updateToken
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getNotifications(id: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": id
        ]
        
        let serviceName = ServiceName.getNotifications
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func updateNotification(id: String, notifId: String, isRead: Bool? = nil, isDeleted: Bool? = nil) -> ResponseData? {
        
        var parameters: Parameters = [
            "user_id": id,
            "notif_id": notifId,
        ]
        
        if let is_read = isRead {
            parameters["is_read"] = "\(is_read)"
        }
        if let is_deleted = isDeleted {
            parameters["is_deleted"] = "\(is_deleted)"
        }

        let serviceName = ServiceName.updateNotification
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getStatementOfAccount(id: String) -> ResponseData? {

        let parameters: Parameters = [
            "user_id": id
        ]
        
        let serviceName = ServiceName.getStatementOfAccount
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func sendContactUs(firstName: String, lastName: String, email: String, phone: String, branchId: String, inquiry: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone": phone,
            "branch_id": branchId,
            "inquiry": inquiry
        ]

        let serviceName = ServiceName.sendContactUs
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func updateStudentStatus(childId: String, hasArrived: Bool, dateArrived: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "child_id": childId,
            "has_arrived": "\(hasArrived)",
            "date_arrived": dateArrived
        ]
        
        let serviceName = ServiceName.updateStudentStatus
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func addTemperature(sendTemperature: SendTemperature) -> ResponseData? {
        
        let parameters: Parameters = sendTemperature.toDict()

        let serviceName = ServiceName.addTemperature
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func addActivity(sendActivity: SendActivity) -> ResponseData? {
        
        let parameters: Parameters = sendActivity.toDict()

        let serviceName = ServiceName.addActivity
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func publishActivity(publishActivityId: PublishActivityId) -> ResponseData? {
        
        let parameters: Parameters = publishActivityId.toDict()
        
        let serviceName = ServiceName.publishActivity
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func deleteActivity(id: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
        ]
        
        let serviceName = ServiceName.deleteActivity
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func sendMessage(userId: String, childId: String, messageIds: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": userId,
            "child_id": childId,
            "message_ids": messageIds
        ]
        
        let serviceName = ServiceName.sendMessage
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getActivities(childId: String) -> ResponseData? {

        let parameters: Parameters = [
            "child_id": childId
        ]
        
        let serviceName = ServiceName.getActivities
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getParentChildren(userId: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "user_id": userId
        ]
        
        let serviceName = ServiceName.getParentChildren
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func uploadImage(image : UIImage, completion:@escaping(_:ResponseData)->Void) {
        self.uploadImageData(serviceName: ServiceName.uploadImage, imageFile: image, completion: completion)
    }
    
    func uploadImageData(serviceName: String, imageFile : UIImage, completion:@escaping(_:ResponseData)->Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let imageData = imageFile.jpeg(.medium)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: BaseUrl + serviceName, headers: headers)
        { (result) in
            let responseData = ResponseData()
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                
                upload.responseJSON { response in
                    if let json = response.result.value as? NSDictionary {
                        responseData.status = ResponseStatus.SUCCESS.rawValue
                        responseData.json = [json]
                        
                        completion(responseData)
                    } else {
                        responseData.status = ResponseStatus.FAILURE.rawValue
                        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
                        responseData.json = nil
                        completion(responseData)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                responseData.status = ResponseStatus.FAILURE.rawValue
                responseData.json = nil
                completion(responseData)
            }
        }
    }
    
    // MARK: /************* SERVER REQUEST *************/
    
    private func makeHttpRequest(method: HTTPMethod, serviceName: String = "", parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, isConfig: Bool = false) -> ResponseData {
        
        var requestUrl = BaseUrl
        if isConfig {
            requestUrl = Services.ConfigUrl
        }

        let response = manager.request(requestUrl + serviceName, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(options: .allowFragments)
        let responseData = ResponseData()
        responseData.status = ResponseStatus.FAILURE.rawValue
        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
        if let token = response.response?.allHeaderFields[Keys.AccessToken.rawValue] as? String{
            UserDefaults.standard.set(token, forKey: Keys.AccessToken.rawValue)
        }
        if let jsonArray = response.result.value as? [NSDictionary] {
            let json = jsonArray.first
            if let status = json!["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json!["message"] as? String {
                responseData.message = message
            }
            if let message = json!["message"] as? Bool {
                responseData.message = String(message)
            }
            
            if let json = jsonArray.last {
                responseData.json = [json]
            }
            
        } else if let json = response.result.value as? NSDictionary {
            if let status = json["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json["message"] as? String {
                responseData.message = message
            }
            if let message = json["message"] as? Bool {
                responseData.message = String(message)
            }
            
            responseData.json = [json]
            
        } else if let jsonArray = response.result.value as? NSArray {
            if let jsonStatus = jsonArray.firstObject as? NSDictionary {
                if let status = jsonStatus["status"] as? Int {
                    responseData.status = status
                }
            }
            
            if let jsonData = jsonArray.lastObject as? NSArray {
                responseData.json = [NSDictionary]()
                for jsonObject in jsonData {
                    if let json = jsonObject as? NSDictionary {
                        responseData.json?.append(json)
                    }
                }
            }
        } else {
            responseData.status = ResponseStatus.FAILURE.rawValue
            responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
            responseData.json = nil
        }
        
        if responseData.status == ResponseStatus.UNAUTHORIZED.rawValue {
            if let baseVC = currentVC as? BaseViewController {
//                baseVC.logout()
            }
        }
        
        return responseData
        
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 30
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["192.168.0.102": .disableEvaluation]
        
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//        return SessionManager(configuration: configuration)
        
    }()
    
    static func getBaseUrl() -> String {
        return _BaseUrl
    }
    
    static func setBaseUrl(url: String) {
        _BaseUrl = url
    }
    
    static func getMediaUrl() -> String {
        return _MediaUrl
    }
    
    static func setMediaUrl(url: String) {
        _MediaUrl = url
    }
}
