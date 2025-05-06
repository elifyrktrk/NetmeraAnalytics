import XCTest

class PushNotificationUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testPushNotificationFlow() {
        // 1. Uygulamayı başlat (zaten setUp'da yapıldı)
        
        // 2. Sol menüyü aç
        openSideMenu()
        
        // 3. Sol menüden "Test Netmera" seçeneğine tıkla
        selectMenuItem(named: "Test Netmera")
        
        // 4. Test Netmera ekranında "Test Push" butonuna tıkla
        let testPushButton = app.buttons["Test Push Notification"]
        XCTAssertTrue(testPushButton.waitForExistence(timeout: 5), "Test Push butonu bulunamadı")
        testPushButton.tap()
        
        // 5. Açılan sayfada "Send Push Notification" butonuna tıkla
        let sendButton = app.buttons["Send Push Notification"]
        XCTAssertTrue(sendButton.waitForExistence(timeout: 5), "Send Push Notification butonu bulunamadı")
        sendButton.tap()
        
        // İşlem sonrası alert'i kapat
        let alert = app.alerts.firstMatch
//        if alert.waitForExistence(timeout: 5) {
//            alert.buttons["OK"].tap()
//        }
        let pushAlert = app.alerts["Push Geldi"]
        XCTAssertTrue(pushAlert.waitForExistence(timeout: 10), "Push alert'i çıkmadı")

        // İstersen 'Tamam' butonuna bas:
//        pushAlert.buttons["Tamam"].tap()

    }
    func testPushNotificationWithSoundFlow() {
        openSideMenu()
        selectMenuItem(named: "Test Netmera")
        
        
        // Send Push Notification butonuna bas
        let testPushButton = app.buttons["Test Push Notification"]
        XCTAssertTrue(testPushButton.waitForExistence(timeout: 5), "Test Push butonu bulunamadı")
        testPushButton.tap()
        
        let soundSelectionView = app.otherElements["SoundPicker"]
        XCTAssertTrue(soundSelectionView.waitForExistence(timeout: 5), "Sound picker bulunamadı")
        soundSelectionView.tap()

        let soundButton = app.sheets.buttons["hp.mp3"] // Seçmek istediğin sesi buraya yaz
        XCTAssertTrue(soundButton.waitForExistence(timeout: 5), "Sound seçimi bulunamadı")
        soundButton.tap()

        
        let sendButton = app.buttons["Send Push Notification"]
        XCTAssertTrue(sendButton.waitForExistence(timeout: 5), "Send Push Notification butonu bulunamadı")
        sendButton.tap()
        
        // Push alert'ini doğrula
        var pushAlert = app.alerts["Push Geldi"]
        XCTAssertTrue(pushAlert.waitForExistence(timeout: 10), "Push alert'i çıkmadı")
    
    
       
     
    
     

    }
    
    
    // MARK: - Yardımcı Metotlar
    
    private func openSideMenu() {
        // Menü butonunu bul ve tıkla
        let menuButton = app.navigationBars.buttons["menu"]
        if menuButton.waitForExistence(timeout: 5) {
            menuButton.tap()
        } else {
            // Eğer menü butonu bulunamazsa, ekranın solundan sağa kaydırarak menüyü açmayı dene
            app.swipeRight()
        }
    }
    
    private func selectMenuItem(named itemName: String) {
        // Menü öğesini bulmak için predicate kullan
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", itemName)
        let menuItem = app.staticTexts.matching(predicate).firstMatch
        
        if menuItem.waitForExistence(timeout: 5) {
            menuItem.tap()
        } else {
            XCTFail("\(itemName) menü öğesi bulunamadı")
        }
    }
}
