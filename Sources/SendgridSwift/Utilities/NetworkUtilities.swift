//
//  NetworkUtilities.swift
//  SendgridSwift
//
//  Created by Keshava Karthik on 22/12/19.
//

import Foundation
import PerfectCURL


public final class NetworkUtilities {
    
    typealias HeaderNames = [(PerfectCURL.CURLRequest.Header.Name, String)]
    
    public static let shared = NetworkUtilities()
    private init () {
    }
    
    /// Synchronous Requests
    /// Return Response Code , Reponse String and Reponse JSON
    func synchronousNetworkRequest(_ requestUrl:String, httpMethod: HTTPMethod, authorization: String,
                                          postString: String, headers:HeaderNames) -> (Int?,String?,[String:Any]?) {
        
       
        
        switch httpMethod {
         case .get,
              .head,
              .options:
             do {
                let curlResponse = try CURLRequest(requestUrl,.httpMethod(httpMethod),
                                            .addHeaders(headers),.addHeader(.authorization,
                                            authorization)).perform()
            
                let response        = curlResponse
                let responseCode    = response.responseCode
                let responseString  = response.bodyString
                let responseJSON    = response.bodyJSON
                return (responseCode,responseString,responseJSON)
             } catch {
                return (400,"Request Failed",nil)
             }
            
         case .post,
              .put,
              .delete :
             do {
                let curlResponse = try CURLRequest(requestUrl,.httpMethod(httpMethod),
                                           .postString(postString),
                                           .addHeaders(headers),.addHeader(.authorization,
                                           authorization)).perform()
           
               let response        = curlResponse
               let responseCode    = response.responseCode
               let responseString  = response.bodyString
               let responseJSON    = response.bodyJSON
               return (responseCode,responseString,responseJSON)
            } catch {
               return (400,"Request Failed",nil)
            }
        default:
            return (400,nil,nil)
        }
    }
    
    func asynchronousNetworkRequest(_ requestUrl:String, httpMethod: HTTPMethod, authorization: String,
                                             postString: String, headers:HeaderNames,
                                             completion:@escaping(Int?,String?,[String:Any]?)->Void) {
           switch httpMethod {
            case .get,
                 .head,
                 .options:
                
                    CURLRequest(requestUrl,.httpMethod(httpMethod),
                                .addHeaders(headers),
                                .addHeader(.authorization,authorization))
                        .perform
                        {
                            confirmation in
                                do {
                                   let response        = try confirmation()
                                   let responseCode    = response.responseCode
                                   let responseString  = response.bodyString
                                   let responseJSON    = response.bodyJSON
                                   completion (responseCode,responseString,responseJSON)
                                   return
                                } catch {
                                   completion (400,"Request Failed",nil)
                                   return
                                }
                            
                        }
            case .post,
                 .put,
                 .delete :
                CURLRequest(requestUrl,.httpMethod(httpMethod),
                            .postString(postString),.addHeaders(headers),
                            .addHeader(.authorization,authorization))
                    .perform {
                        confirmation in
                            do {
                               let response        = try confirmation()
                               let responseCode    = response.responseCode
                               let responseString  = response.bodyString
                               let responseJSON    = response.bodyJSON
                               completion (responseCode,responseString,responseJSON)
                               return
                            } catch {
                               completion (400,"Request Failed",nil)
                               return
                            }
               }
           default:
               completion (400,nil,nil)
               return
           }
       }
}
