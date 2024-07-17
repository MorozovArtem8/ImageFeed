//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Artem Morozov on 16.07.2024.
//

import XCTest
//import WebKit

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 2))
        
        loginTextField.tap()
        sleep(2)
        loginTextField.typeText("vjhjpjaa32@yandex.ru")
        
        sleep(1)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2))
        app.toolbars.buttons["Done"].tap()
        passwordTextField.tap()
        sleep(1)
        passwordTextField.tap()
        passwordTextField.typeText("Vjhjpjaa321q")
        
        sleep(1)
        app.toolbars.buttons["Done"].tap()
        sleep(1)
        
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
        
        sleep(3)
        
        let tablesQuery =  app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
    }
    
    func testFeed() throws {
        let tablesQuery =  app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
        let likeButton = cell.children(matching: .button).element
        XCTAssertTrue(likeButton.exists)
        likeButton.tap()
        sleep(1)
        likeButton.tap()
        sleep(1)
        
        cell.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertFalse(cell.exists)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
        
        let backButton = app.buttons.firstMatch
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        sleep(1)
        XCTAssertTrue(cell.exists)
    }
    
    func testProfile() throws {
        let profileButton = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileButton.waitForExistence(timeout: 3))
        profileButton.tap()
        let name = app.staticTexts["Artem Morozov"].exists
        let loginName = app.staticTexts["@morozovartem8"].exists
        let bio = app.staticTexts["hello world"].exists
        XCTAssertTrue(name)
        XCTAssertTrue(loginName)
        XCTAssertTrue(bio)
        
        let logoutButton = app.buttons["exitButton"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 1))
        logoutButton.tap()
        
        let yesButton = app.alerts["Alert"].scrollViews.otherElements.buttons["Да"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 2))
        yesButton.tap()
        sleep(1)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
    
}
//let passwordTextField = webView.descendants(matching: .secureTextField).element
//XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
//passwordTextField.tap()
//sleep(3)
//XCUIApplication().toolbars.buttons["Done"].tap() // maintain the possible test fail because of keyboard lag
//passwordTextField.tap()
//passwordTextField.typeText("paste you password")
//sleep(3)
//XCUIApplication().toolbars.buttons["Done"].tap()
