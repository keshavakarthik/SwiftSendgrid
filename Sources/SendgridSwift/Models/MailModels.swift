//
//  MailModels.swift
//  SendgridSwift
//
//  Created by Keshava Karthik on 22/12/19.
//

import Foundation

/// User class represents the Sender, Intended Receipient and other receipients in cc and bcc field.User has two properties email and name. email is mandatory and name is optional
public final class User : StringValuePairConvertible {
    let email   :   String
    let name    :   String?
    
    init(email:String, name:String? = nil) {
        self.email = email
        self.name  = name
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValue = [String:Any]()
        jsonValue["email"] = self.email
        if self.name != nil {
            jsonValue["name"] = self.name
        }
        return jsonValue
    }
}

/// Personalizations Class
public final class Personalization : StringValuePairConvertible {
    let receipients     :   [User]
    let ccReceipients   :   [User]
    let bccReceipients  :   [User]
    let subject         :   String?
    let headers         :   [String:Any]?
    let substitutions   :   [String:Any]?
    let customArgs      :   [String:Any]?
    let sendAt          :   Int64?
    
    init(receipients: [User], ccReceipients: [User], bccReceipients: [User],
         subject: String, headers: [String:Any]? = nil, substitutions: [String:Any]?  = nil,
         customArgs: [String:Any]?  = nil, sendAt: Int64? = nil) {
        self.receipients        =   receipients
        self.ccReceipients      =   ccReceipients
        self.bccReceipients     =   bccReceipients
        self.subject            =   subject
        self.headers            =   headers
        self.substitutions      =   substitutions
        self.customArgs         =   customArgs
        self.sendAt             =   sendAt
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValue           =   [String:Any]()
        jsonValue["to"]         =   self.receipients.stringValuePairs
        jsonValue["cc"]         =   self.ccReceipients.stringValuePairs
        jsonValue["bcc"]        =   self.bccReceipients.stringValuePairs
        jsonValue["subject"]    =   self.subject
        if self.headers != nil {
            jsonValue["headers"]        =   self.headers
        }
        if self.substitutions != nil {
            jsonValue["substitutions"]  =   self.substitutions
        }
        if self.customArgs != nil {
            jsonValue["custom_args"]    =   self.customArgs
        }
        if self.sendAt != nil {
            jsonValue["send_at"]        =   self.sendAt
        }
        return jsonValue
    }
}

/// Mail Content Model
public final class MailContent : StringValuePairConvertible {
    let mimeType        :   String
    let content         :   String
    
    init(mimeType: String = "text/plain", content: String) {
        self.mimeType       =   mimeType
        self.content        =   content
    }
    
    var stringValuePairs: StringValuePair {
        return [
            "type"      :   self.mimeType,
            "value"     :   self.content
        ]
    }
}

/// Mail Attachment Model
public final class MailAttachment : StringValuePairConvertible {
    let mimeType        :   String
    let content         :   String
    let filename        :   String
    let disposition     :   String
    let contentId       :   String?
    
    init(mimeType: String = "text/plain", content: String, filename: String, disposition: String = "attachment",
         contentId: String? = nil) {
        self.mimeType       =   mimeType
        self.content        =   content
        self.filename       =   filename
        self.disposition    =   disposition
        self.contentId      =   contentId
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValue               =   [String:Any]()
        jsonValue["type"]           =   self.mimeType
        jsonValue["content"]        =   self.content
        jsonValue["filename"]       =   self.filename
        jsonValue["disposition"]    =   self.disposition
        if self.contentId != nil {
            jsonValue["content_id"] =   self.contentId
        }
        return jsonValue
    }
}

/// Mail ASM Model
public final class MailAsm : StringValuePairConvertible {
    let groupId             :   Int
    let groupsToDisplay     :   [Int]?
    
    init(groupId:Int, groupsToDisplay: [Int]? = nil) {
        self.groupId            =   groupId
        self.groupsToDisplay    =   groupsToDisplay
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValue = [String:Any]()
        jsonValue["group_id"]   =   self.groupId
        if groupsToDisplay != nil {
            jsonValue["groups_to_display"] = self.groupsToDisplay
        }
        return jsonValue
    }
}

/// Mail Settings Model
public final class MailSettings : StringValuePairConvertible {
    let bccEnable           :   Bool
    let bccEmail            :   String?
    let bypassEnable        :   Bool
    let footerEnable        :   Bool
    let footerText          :   String?
    let footerHtml          :   String?
    let sandboxModeEnable   :   Bool
    let spamCheckModeEnable :   Bool
    let spamThreshold       :   Int?
    let spamPostToUrl       :   String?
    
    init(bccEnable: Bool = false, bccEmail: String? = nil, bypassEnable: Bool = false, footerEnable: Bool = false,
         footerText: String? = nil, footerHtml: String? = nil, sandboxModeEnable: Bool = false,
         spamCheckModeEnable: Bool = false, spamThreshold: Int? = nil, spamPostToUrl: String? = nil) {
        self.bccEnable              =   bccEnable
        self.bccEmail               =   bccEmail
        self.bypassEnable           =   bypassEnable
        self.footerEnable           =   footerEnable
        self.footerText             =   footerText
        self.footerHtml             =   footerHtml
        self.sandboxModeEnable      =   sandboxModeEnable
        self.spamCheckModeEnable    =   spamCheckModeEnable
        self.spamThreshold          =   spamThreshold
        self.spamPostToUrl          =   spamPostToUrl
    }
    
    var stringValuePairs: StringValuePair {
         var jsonValue               =   [String:Any]()
         if bccEnable {
            guard let bcc = bccEmail else {
                return [:]
            }
            jsonValue["bcc"] = ["enable":self.bccEnable,"email":bcc]
         }
         if bypassEnable {
            jsonValue["bypass_list_management"] = ["enable":self.bypassEnable]
         }
         if footerEnable {
            guard let textFooter = footerText else {
                return [:]
            }
            guard let htmlFooter = footerHtml else {
                return [:]
            }
            jsonValue["footer"] = ["enable":self.footerEnable,"text":textFooter,"html":htmlFooter]
         }
         if sandboxModeEnable {
            jsonValue["sandbox_mode"] = ["enable":self.sandboxModeEnable]
         }
         if spamCheckModeEnable {
            guard let threshold = spamThreshold else {
                return [:]
            }
            guard let postToUrl = spamPostToUrl else {
                return [:]
            }
            jsonValue["spam_check"] = ["enable":self.spamCheckModeEnable,"threshold":threshold,"post_to_url":postToUrl]
         }
         return jsonValue
    }
}

///Mail Tracking Settings Model
public final class MailTrackSettings : StringValuePairConvertible {
    
    let clickTrackingEnable             :   Bool
    let clickTrackingText               :   String?
    let openTrackingEnable              :   Bool
    let openSubstitutionTag             :   String?
    let subscriptionEnable              :   Bool
    let subscriptionTrackingText        :   String?
    let subscriptionTrackingHtml        :   String?
    let subscriptionSubstitutionTag     :   String?
    
    init(clickTrackingEnable: Bool, clickTrackingText: String? = nil, openTrackingEnable: Bool,
         openSubstitutionTag: String? = nil, subscriptionEnable: Bool, subscriptionTrackingText: String? = nil,
         subscriptionTrackingHtml: String? = nil, subscriptionSubstitutionTag: String? = nil) {
        self.clickTrackingEnable            =   clickTrackingEnable
        self.clickTrackingText              =   clickTrackingText
        self.openTrackingEnable             =   openTrackingEnable
        self.openSubstitutionTag            =   openSubstitutionTag
        self.subscriptionEnable             =   subscriptionEnable
        self.subscriptionTrackingText       =   subscriptionTrackingText
        self.subscriptionTrackingHtml       =   subscriptionTrackingHtml
        self.subscriptionSubstitutionTag    =   subscriptionSubstitutionTag
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValues = [String:Any]()
        if self.clickTrackingEnable {
            guard let trackingText  = clickTrackingText else {
                return [:]
            }
            jsonValues["click_tracking"] = ["enable":self.clickTrackingEnable,"enable_text":trackingText]
        }
        if self.openTrackingEnable {
            guard let substitutionTag = openSubstitutionTag else {
                return [:]
            }
            jsonValues["open_tracking"] =   ["enable": self.openTrackingEnable,
                                             "substitution_tag": substitutionTag]
        }
        if self.subscriptionEnable {
            guard let subscriptionText = self.subscriptionTrackingText else {
                return [:]
            }
            guard let subscriptionHtml = self.subscriptionTrackingHtml else {
                return [:]
            }
            guard let substitutionTag = self.subscriptionSubstitutionTag else {
                return [:]
            }
            jsonValues["subscription_tracking"] = ["enable":self.subscriptionEnable,"text":subscriptionText,
                                                   "html": subscriptionHtml,"substitution_tag":substitutionTag]
        }
        return jsonValues
    }
}

///Mail Google Analytics Model
public final class MailGAAnalytics : StringValuePairConvertible {
    
    let enable          :   Bool
    let utmSource       :   String?
    let utmMedium       :   String?
    let utmTerm         :   String?
    let utmContent      :   String?
    let utmCampaign     :   String?
    
    init(enable: Bool, utmSource: String? = nil, utmMedium: String? = nil, utmTerm: String? = nil,
         utmContent: String? = nil,utmCampaign: String? = nil) {
        self.enable         =   enable
        self.utmSource      =   utmSource
        self.utmMedium      =   utmMedium
        self.utmTerm        =   utmTerm
        self.utmCampaign    =   utmCampaign
        self.utmContent     =   utmContent
    }
    
    var stringValuePairs: StringValuePair {
        var jsonValues = [String:Any]()
        if self.enable {
            guard let source = utmSource else {
                return [:]
            }
            guard let medium = utmMedium else {
                return [:]
            }
            guard let term = utmTerm else {
                return [:]
            }
            guard let content = utmContent else {
                return [:]
            }
            guard let campaign = utmCampaign else {
                return [:]
            }
            jsonValues["enable"]        =   self.enable
            jsonValues["utm_source"]    =   source
            jsonValues["utm_medium"]    =   medium
            jsonValues["utm_term"]      =   term
            jsonValues["utm_content"]   =   content
            jsonValues["utm_campaign"]  =   campaign
            return jsonValues
        } else {
            return [:]
        }
        
    }
}

