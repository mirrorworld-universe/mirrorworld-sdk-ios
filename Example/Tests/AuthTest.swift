//
//  AuthTest.swift
//  MirrorWorldSDK_Tests
//
//  Created by ZMG on 2022/11/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest

import MirrorWorldSDK

final class AuthTest: XCTestCase {

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

 

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testInitSDK() throws {
        let apiKey = "mw_testIb0RM5IMP5UmgSwIAu4qCGPTP1BO7Doq1GN"
        MirrorWorldSDK.share.initSDK(env: .StagingDevNet,chain:MWChain.Solana, apiKey: apiKey)
        XCTAssertTrue(MWSDK.sdkConfig.apiKey.count>0,"init success")
    }
    
//    func testStartLogin() throws {
//        let exp = expectation(description: #function)
//        
//        let urlString = testSDKConfig.environment.mainRoot + testSDKConfig.apiKey
//        XCTAssertNotNil(urlString)
//        
//        MirrorWorldSDK.share.initSDK(config: testSDKConfig)
//        MWSDK.StartLogin { userInfo in
//            XCTAssertTrue(userInfo?.count ?? 0 > 0 , "login success")
//            exp.fulfill()
//        } onFail: {
//            XCTFail()
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 60,handler: nil)
//    }
//    
//    func testloginOut() throws {
//        
//        let exp = expectation(description: #function)
//
//        MWSDK.Logout {
//            XCTAssertNil(MirrorWorldSDKAuthData.share.userInfo,"logOut success !")
//            exp.fulfill()
//        } onFail: {
//            XCTFail()
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 60,handler: nil)
//
//    }
//    
//    func testCheckAuthenticated()throws{
//        
//        let exp = expectation(description: #function)
//
//        MWSDK.CheckAuthenticated { onBool in
//            XCTAssert(onBool)
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 10,handler: nil)
//    }
    
   
    
    

}
