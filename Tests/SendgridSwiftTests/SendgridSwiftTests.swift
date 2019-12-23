//
//  SendgridSwiftTests.swift
//  SendgridSwiftTests
//
//  Created by Keshava Karthik on 23/12/19.
//

import Foundation
import XCTest
@testable import SendgridSwift

class SendgridSwiftTets : XCTestCase {
    
    func testUserModel() {
        var user            = User(email: "xyz@abc.com")
        var userDictionary  = user.stringValuePairs
        
        XCTAssertNil(userDictionary["name"] as? String, "User name is NIL")
        XCTAssert(userDictionary["email"] as? String == "xyz@abc.com", "User email is not NIL")
        
        user                = User(email: "name@noname.com", name: "Name")
        userDictionary      = user.stringValuePairs
        
        XCTAssert(userDictionary["name"] as? String == "Name", "User Name is not NIL")
        XCTAssert(userDictionary["email"] as? String == "name@noname.com", "User email is not NIL")
    }
    
    func testPersonalizationModel() {
        
        let recepientOne    = User(email: "recipient@one.com", name: "Receipient One")
        let recepientTwo    = User(email: "recipient@two.com", name: "Receipient Two")
        
        let ccRecepientOne  = User(email: "ccrecipient@one.com", name: "CCReceipient One")
        let ccRecepientTwo  = User(email: "ccrecipient@one.com", name: "CCReceipient One")
        
        let bccRecepientOne  = User(email: "bccrecipient@one.com", name: "BCCReceipient One")
        let bccRecepientTwo  = User(email: "bccrecipient@one.com", name: "BCCReceipient One")
        
        
        var personalization =   Personalization(receipients: [recepientOne,recepientTwo],
                                                ccReceipients: [ccRecepientOne,ccRecepientTwo],
                                                bccReceipients: [bccRecepientOne,bccRecepientTwo],
                                                subject: "Sample Mail Subject")
        var personalizationDictionary = personalization.stringValuePairs
        
        XCTAssert((personalizationDictionary["to"] as? [[String:Any]])?.count == 2, "To user initialized")
        XCTAssert((personalizationDictionary["cc"] as? [[String:Any]])?.count == 2, "CC user initialized")
        XCTAssert((personalizationDictionary["bcc"] as? [[String:Any]])?.count == 2, "BCC user initialized")
        XCTAssert(personalizationDictionary["subject"] as? String == "Sample Mail Subject", "Subject initialized")
        
        personalization  = Personalization(receipients: [recepientOne,recepientTwo],
                                           ccReceipients: [ccRecepientOne,ccRecepientTwo],
                                           bccReceipients: [bccRecepientOne,bccRecepientTwo],
                                           subject: "Sample Mail Subject",
                                           headers: ["header1":"value1","header2":"value2"],
                                           substitutions: ["sub1":"value1"],
                                           customArgs: ["arg1":"value1","arg2":"value2"],
                                           sendAt: 34567893214)
        
        personalizationDictionary = personalization.stringValuePairs
        
        XCTAssert((personalizationDictionary["to"] as? [[String:Any]])?.count == 2, "To user initialized")
        XCTAssert((personalizationDictionary["cc"] as? [[String:Any]])?.count == 2, "CC user initialized")
        XCTAssert((personalizationDictionary["bcc"] as? [[String:Any]])?.count == 2, "BCC user initialized")
        XCTAssert(personalizationDictionary["subject"] as? String == "Sample Mail Subject", "Subject initialized")
        XCTAssert(personalizationDictionary["headers"] as? [String:Any] != nil, "Headers Initialized")
        XCTAssert(personalizationDictionary["substitutions"] as? [String:Any] != nil, "Substitutions initialized")
        XCTAssert(personalizationDictionary["custom_args"] as? [String:Any] != nil, "Custom Arguments initialized")
        XCTAssert(personalizationDictionary["send_at"] as? Int64 == 34567893214, "Send At initialized")
    }
}
