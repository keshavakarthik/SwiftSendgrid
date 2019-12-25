//
//  Mail.swift
//  SendgridSwift
//
//  Created by Keshava Karthik on 21/12/19.
//

import Foundation
import PerfectLib

//MARK: Mail Class
public final class Mail : StringValuePairConvertible {
    
    let personalizations        :   [Personalization]
    let mailSender              :   User
    let replyTo                 :   User
    let mailSubject             :   String
    let mailContent             :   MailContent
    let mailAttachments         :   MailAttachment?
    let templateId              :   String?
    let sections                :   [String:Any]?
    let headers                 :   [String:Any]?
    let categories              :   [String]?
    let customArgs              :   String?
    let sendAt                  :   Int64?
    let batchId                 :   String?
    let asm                     :   MailAsm?
    let ipPoolName              :   String?
    let mailSettings            :   MailSettings?
    let trackingSettings        :   MailTrackSettings?
    let googleAnalytics         :   MailGAAnalytics?
    
    init(personalizations : [Personalization], mailSender: User, replyTo: User, mailSubject: String,
         mailContent: MailContent, mailAttachments : MailAttachment? = nil, templateId: String? = nil,
         sections: [String:Any]? = nil, headers: [String:Any]? = nil, categories: [String]? = nil,
         customArgs: String? = nil, sendAt: Int64? = nil, batchId: String? = nil, asm: MailAsm? = nil,
         ipPoolName: String? = nil, mailSettings: MailSettings? = nil, trackingSettings: MailTrackSettings? = nil,
         googleAnalytics: MailGAAnalytics? = nil) {
        self.personalizations       =   personalizations
        self.mailSender             =   mailSender
        self.replyTo                =   replyTo
        self.mailSubject            =   mailSubject
        self.mailContent            =   mailContent
        self.mailAttachments        =   mailAttachments
        self.templateId             =   templateId
        self.sections               =   sections
        self.headers                =   headers
        self.categories             =   categories
        self.customArgs             =   customArgs
        self.sendAt                 =   sendAt
        self.batchId                =   batchId
        self.asm                    =   asm
        self.ipPoolName             =   ipPoolName
        self.mailSettings           =   mailSettings
        self.trackingSettings       =   trackingSettings
        self.googleAnalytics        =   googleAnalytics
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValues  =   [String:Any]()
        jsonValues["personalizations"]      =   self.personalizations.stringValuePairs
        jsonValues["from"]                  =   self.mailSender.stringValuePairs
        jsonValues["reply_to"]              =   self.replyTo.stringValuePairs
        jsonValues["subject"]               =   self.mailSubject
        if self.mailAttachments != nil {
            jsonValues["attachments"]       =   self.mailAttachments?.stringValuePairs
        }
        if self.templateId != nil {
            jsonValues["template_id"]       =   self.templateId
        }
        if self.sections != nil {
            jsonValues["sections"]          =   self.sections
        }
        if self.headers != nil {
            jsonValues["headers"]           =   self.headers
        }
        if self.categories != nil {
            jsonValues["categories"]        =   self.categories
        }
        if self.customArgs != nil {
            jsonValues["custom_args"]       =   self.customArgs
        }
        if self.sendAt  != nil {
            jsonValues["send_at"]           =   self.sendAt
        }
        if self.batchId != nil {
            jsonValues["batch_id"]          =   self.batchId
        }
        if self.asm != nil {
            jsonValues["asm"]               =   self.asm?.stringValuePairs
        }
        if self.ipPoolName != nil {
            jsonValues["ip_pool_name"]      =   self.ipPoolName
        }
        if self.mailSettings != nil {
            jsonValues["mail_settings"]     =   self.mailSettings?.stringValuePairs
        }
        if self.trackingSettings != nil {
            jsonValues["tracking_settings"] =   self.trackingSettings?.stringValuePairs
        }
        if self.googleAnalytics != nil {
            jsonValues["ganalytics"]        =   self.googleAnalytics?.stringValuePairs
        }
        
        return jsonValues
    }
}

//MARK: Mail Interfaces
extension Mail {
    
    public func sendMail(apiKey:String,
                         completion:@escaping(Int?,String?,[String:Any]?)->Void) {
        do{
            let mail            = self.stringValuePairs
            let mailString      = try mail.jsonEncodedString()
            let targetURL       = Sendgrid.MAIL_SEND_V3
            let authroization   = "Bearer " + apiKey
            NetworkUtilities.shared.asynchronousNetworkRequest(targetURL, httpMethod: .post, authorization: authroization,
                                                               postString: mailString, headers: [(.contentType,"application/json")])
            {
                (responseCode,responseString,responseJSON) in
                 
                completion(responseCode,responseString,responseJSON)
                return
            }
            
        } catch {
            completion(400,nil,["status":"FAILURE","message":"JSON Conversion failed for Mail Object"])
            return
        }
    }
}
