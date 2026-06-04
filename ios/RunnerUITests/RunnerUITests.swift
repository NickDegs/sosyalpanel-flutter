import XCTest

class RunnerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        // fastlane snapshot için gerekli
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshots() throws {
        let app = XCUIApplication()

        // Dashboard
        sleep(3)
        snapshot("01_Dashboard")

        // Tab bar varsa diğer ekranlar
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            let tabs = tabBar.buttons
            if tabs.count > 1 {
                tabs.element(boundBy: 1).tap()
                sleep(2)
                snapshot("02_Composer")
            }
            if tabs.count > 2 {
                tabs.element(boundBy: 2).tap()
                sleep(2)
                snapshot("03_Analytics")
            }
            if tabs.count > 3 {
                tabs.element(boundBy: 3).tap()
                sleep(2)
                snapshot("04_Platforms")
            }
            if tabs.count > 4 {
                tabs.element(boundBy: 4).tap()
                sleep(2)
                snapshot("05_Settings")
            }
        }
    }
}
