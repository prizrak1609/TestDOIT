//
//  TestDOITUITests.swift
//  TestDOITUITests
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest

class TestDOITUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
         XCTAssertTrue(true)
    }

    func testOpenAndFillRegisterScreen() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        app.images["Person-placeholder"].tap()
        app.sheets["Get image from:"].buttons["Camera"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        app.buttons["Use Photo"].tap()
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("geel")
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        let emailTextField = app.textFields["Email"]
        emailTextField.typeText("tesst")
        nextButton.tap()
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.typeText("test")
        app.otherElements.containing(.navigationBar, identifier:"Register").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["Register"].buttons["Login"].tap()
    }

    func testOpenAndFillLoginScreen() {
        let app = XCUIApplication()
        let element = app.otherElements.containing(.navigationBar, identifier:"Login").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.tap()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("gubatenkod@icloud.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("test")
        element.tap()
        emailTextField.tap()
        app.buttons["Next:"].tap()
        app.buttons["Done"].tap()
        app.buttons["Login"].tap()
    }

    func testOpenMainScreen() {
        testOpenAndFillLoginScreen()
        let app = XCUIApplication()
        let collectionView = app.otherElements.containing(.navigationBar, identifier:"TestDOIT.MainScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        collectionView.tap()
        collectionView.tap()
        collectionView.tap()
    }

    func testShowGif() {
        testOpenMainScreen()
        let app = XCUIApplication()
        let playButton = app.navigationBars["TestDOIT.MainScreen"].buttons["Play"]
        playButton.tap()
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1)
        let element = element2.children(matching: .other).element
        element.tap()
        playButton.tap()
        element.tap()
        playButton.tap()
        element2.tap()
    }

    func testAddGif() {
        testOpenMainScreen()
        let app = XCUIApplication()
        app.navigationBars["TestDOIT.MainScreen"].buttons["Add"].tap()
        app.images["imagePlaceholder"].tap()
        app.sheets["Get image from:"].buttons["Camera"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.tap()
        app.buttons["Retake"].tap()
        element.tap()
        app.buttons["Use Photo"].tap()
        let descriptionTextField = app.textFields["description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("ddescrr")
        let app2 = app
        app2.buttons["Return"].tap()
        descriptionTextField.typeText("\n")
        let element2 = app.otherElements.containing(.navigationBar, identifier:"Upload Image").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element2.tap()
        let hashtagTextField = app.textFields["#hashtag"]
        hashtagTextField.tap()
        app2.keys["more"].tap()
        app2.buttons["shift"].tap()
        hashtagTextField.typeText("#")
        let moreKey = app2.keys["more"]
        moreKey.tap()
        moreKey.tap()
        hashtagTextField.typeText("taag tag")
        element2.tap()
        let checkmarkButton = app.navigationBars["Upload Image"].buttons["checkMark"]
        checkmarkButton.tap()
        hashtagTextField.tap()
        let deleteKey = app2.keys["delete"]
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        element2.tap()
        checkmarkButton.tap()
    }
}
