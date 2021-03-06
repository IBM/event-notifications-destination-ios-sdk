/**
 (C) Copyright IBM Corp. 2021.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  ENPushNotificationActionTests.swift
//  ENPushTests
//
//  Created by Anantha Krishnan K G on 14/02/22.
//

import XCTest
@testable import ENPushDestination

class ENPushNotificationActionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testENPushNotificationAction() throws {
        let actionOne = ENPushNotificationAction(identifierName: "FIRST", buttonTitle: "Accept", isAuthenticationRequired: false, defineActivationMode: .foreground)
        let actionTwo = ENPushNotificationAction(identifierName: "Second", buttonTitle: "decline", isAuthenticationRequired: true, defineActivationMode: .destructive)
        
        XCTAssertNotNil(actionOne)
        XCTAssertNotNil(actionTwo)
        
        XCTAssertEqual(actionOne.title, "Accept")
        XCTAssertEqual(actionOne.identifier, "FIRST")
        XCTAssertEqual(actionOne.authenticationRequired, false)
        XCTAssertEqual(actionOne.activationMode, .foreground)
        
        XCTAssertEqual(actionTwo.title, "decline")
        XCTAssertEqual(actionTwo.identifier, "Second")
        XCTAssertEqual(actionTwo.authenticationRequired, true)
        XCTAssertEqual(actionTwo.activationMode, .destructive)


    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
