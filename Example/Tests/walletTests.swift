//
//  walletTests.swift
//  MirrorWorldSDK_Tests
//
//  Created by ZMG on 2022/11/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import MirrorWorldSDK

final class walletTests: XCTestCase {
    
    var testSDKConfig:MirrorWorldSDKConfig!
    override func setUpWithError() throws {
        testSDKConfig = MirrorWorldSDKConfig()
        testSDKConfig.apiKey = "mw_testIb0RM5IMP5UmgSwIAu4qCGPTP1BO7Doq1GN"
        testSDKConfig.environment = .StagingDevNet
        MirrorWorldSDK.share.initSDK(config: testSDKConfig)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testOpenWallet() throws {
        
//        let exp = expectation(description: #function)
        
//        MWSDK.OpenWallet {
//            XCTAssertFalse(MirrorWorldSDKAuthData.share.refresh_token.count > 0 ,"logout wallet!")
//            exp.fulfill()
//        } loginSuccess: ([String : Any]?) -> ()
//        MWSDK.OpenWallet {
//            XCTAssertFalse(MirrorWorldSDKAuthData.share.refresh_token.count > 0 ,"logout wallet!")
//            exp.fulfill()
//
//        } loginSuccess: { [String : Any]? in
//            exp.fulfill()
//        }
//
//        waitForExpectations(timeout: 60,handler: nil)
        
    }
    
//    func testGetWalletTokens() throws {
//        let exp = expectation(description: #function)
//        MWSDK.GetWalletTokens { data in
//            XCTAssertNotNil(data)
//            exp.fulfill()
//        } onFailed: {
//            XCTFail()
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 10,handler: nil)
//    }
//    
//    
//    func testQueryUser(){
//        let exp = expectation(description: #function)
//        let email = "zg72296@gmail.com"
//        MWSDK.QueryUser(email: email) { userRes in
//            XCTAssertNotNil(userRes)
//            exp.fulfill()
//        } onFetchFailed: { code, err in
//            XCTFail()
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 10,handler: nil)
//    }
//    
//    func testGetAccessToken(){
//        XCTAssertNotNil(MirrorWorldSDKAuthData.share.access_token)
//    }
//    
//  
//    func testGetWalletTransactions() throws{
//        
//        let exp = expectation(description: #function)
//
//        MWSDK.GetWalletTransactions(limit: 10, next_before: "11") { data in
//            XCTAssertNotNil(data)
//            exp.fulfill()
//        } onFailed: {
//            XCTFail()
//            exp.fulfill()
//
//        }
//        waitForExpectations(timeout: 10,handler: nil)
//
//    }
    
    
}
