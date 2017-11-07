//
//  ShoppingCartTests.swift
//  ShoppingCartTests
//
//  Created by surekha Ramchandra Shinde on 05/11/2017.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import XCTest
@testable import ShoppingCart

class ShoppingCartTests: XCTestCase {
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testValidateGetProductsAPIHTTPStatusCode200()
    {
        let expectationRes = expectation(description: "Status code: 200")
        DispatchQueue.global().async
            {
                let productsURL : NSURL = NSURL(string: "https://mobiletest-hackathon.herokuapp.com/getdata/")!
                
                    URLSession.shared.dataTask(with: productsURL as URL)
                    {
                        data, response, error in
                        if let error = error {
                            XCTFail("Error: \(error.localizedDescription)")
                            return
                        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                            if statusCode == 200
                            {
                                expectationRes.fulfill()
                            } else {
                                XCTFail("Status code: \(statusCode)")
                            }
                        }
                        }.resume()
                }
         waitForExpectations(timeout: 10, handler: nil)
        }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
