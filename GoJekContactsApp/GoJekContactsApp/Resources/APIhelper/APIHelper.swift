//
//  APIHelper.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 16/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation

enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class APIHelper: NSObject {
    
    // MARK: - Shared Instance
    
    static let sharedInstance: APIHelper = {
        let instance = APIHelper()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func makeGetApiCallWithMethod(withMethod methodName: String, successHandler: @escaping (_ responseData: Data? ,_ error: Error?) -> Void, failureHandler: @escaping (_ strMessage: String,_ error: Error?) -> Void) {
        
        let urlString = AppConstants.BASEURL + methodName
        let stringEncode = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let myURL = NSURL(string: stringEncode!)!
        let request = NSMutableURLRequest(url: myURL as URL)
        request.httpMethod = HttpMethod.GET.rawValue
        
        request.setValue(AppConstants.ContentTypeJSON, forHTTPHeaderField: AppConstants.AcceptKey)
        request.setValue(AppConstants.ContentTypeJSON, forHTTPHeaderField: AppConstants.ContentType)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // Your completion handler code here
            if let dataReceived = data {
                successHandler(dataReceived, nil)
            } else {
                failureHandler("Some error occured", error)
            }
        }
        task.resume()
    }
    
    func makePostAPICall(url: String,params: Dictionary<String, Any>?, method: HttpMethod, success:@escaping ( Data? ,HTTPURLResponse?  , NSError? ) -> Void, failure: @escaping ( Data? ,HTTPURLResponse?  , NSError? )-> Void) {
        var request : URLRequest?
        var session : URLSession?
        
        let urlString = AppConstants.BASEURL + url + ApiConstants.APIExtension

        request = URLRequest(url: URL(string: urlString)!)
        
        print("URL = \(urlString)")
        print("Params = \(params!)")
        
        if let params = params {
            let  jsonDataRequest = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            request?.setValue(AppConstants.ContentTypeJSON, forHTTPHeaderField: AppConstants.ContentType)
            request?.httpBody = jsonDataRequest//?.base64EncodedData()
        }
        request?.httpMethod = method.rawValue
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        session = URLSession(configuration: configuration)
        
        session?.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
            
            if let data = data {
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    success(data , response , error as NSError?)
                } else {
                    failure(data , response as? HTTPURLResponse, error as NSError?)
                }
            }else {
                failure(data , response as? HTTPURLResponse, error as NSError?)
            }
            }.resume()
    }
}
