//
//  NetworkUtilities.swift
//  SendgridSwift
//
//  Created by Keshava Karthik on 22/12/19.
//

import Foundation
import PerfectCURL

public final class NetworkUtility {
    
    public static let shared = NetworkUtility()
    private init () {
    }
    
    public func asynchronousMailSend(_ targetURL: String, authorization:String, jsonString: String,
                                       completion: @escaping(Bool,[String:Any])->Void) {
        
        
        let curlRequest = CURLRequest(targetURL,
                                      .httpMethod(.post),
                                      .postString(jsonString),
                                      .addHeader(.contentType,"application/json"),
                                      .addHeader(.authorization, authorization))
        curlRequest.perform() {
            confirmation in
            do {
                let sendgridResponse = try confirmation()
                let statusCode = sendgridResponse.responseCode
                if statusCode >= 200 && statusCode <= 300 {
                    completion (true, ["status":"SUCCESS","message":"REQUEST SUCCEEDED. MAIL SENT SUCCESSFULLY"])
                    return
                } else {
                    let errorMessage = sendgridResponse.bodyString
                    completion (false, ["status":"FAILURE","message":"REQUEST FAILED WITH ERROR MESSAGE : \(errorMessage)"])
                    return
                }
            } catch {
                completion (false, ["status":"FAILURE","message":"REQUEST FAILED"])
                return
            }
        }
    }
}
