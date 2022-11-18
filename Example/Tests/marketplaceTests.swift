//
//  marketplaceTests.swift
//  MirrorWorldSDK_Tests
//
//  Created by ZMG on 2022/11/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import MirrorWorldSDK

final class marketplaceTests: XCTestCase {

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

    
    func testMintNewNFT(){
        let exp = expectation(description: #function)

        MWSDK.MintNewNFT(collection_mint: "", name: "testNFT", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", seller_fee_basis_points: 500, confirmation: "finalized") { data in
            XCTAssertNotNil(data)
            exp.fulfill()

        } onFailed: { code, message in
            XCTFail()
            exp.fulfill()
        }
        waitForExpectations(timeout: 15,handler: nil)

    }
    
    func testMintNewCollection(){
        let exp = expectation(description: #function)
        
        MWSDK.MintNewCollection(name: "testColleciton", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", confirmation: "finalized", seller_fee_basis_points: 200) { data in
            XCTAssertNotNil(data)
            exp.fulfill()

        } onFailed: { code, message in
            XCTFail()
            exp.fulfill()

        }
        waitForExpectations(timeout: 60,handler: nil)
    }
    
    func testCreateVerifiedSubCollection() throws{
        
        let exp = expectation(description: #function)

        MWSDK.CreateVerifiedSubCollection(name: "test", collection_mint: "xxxxxxxx", symbol: "test", url: "https://market-assets.mirrorworld.fun/gen1/1.json") { data in
            XCTAssertNotNil(data)
            exp.fulfill()
        } onFailed: { code, message in
            XCTFail(message ?? "failed")
            exp.fulfill()
        }
        waitForExpectations(timeout: 60,handler: nil)

    }
    
}
