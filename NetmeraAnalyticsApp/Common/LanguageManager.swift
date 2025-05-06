import Foundation
import UIKit

class LanguageManager {
    static let shared = LanguageManager()
    private init() {}

    var currentLanguage: String {
        get {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? Locale.preferredLanguages.first ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AppLanguage")
            Bundle.setLanguage(newValue)
        }
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0
    static func setLanguage(_ language: String) {
        object_setClass(Bundle.main, PrivateBundle.self)
        objc_setAssociatedObject(Bundle.main, &Bundle.bundleKey, language, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    private class PrivateBundle: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            let language = objc_getAssociatedObject(self, &Bundle.bundleKey) as? String ?? "en"
            guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                return super.localizedString(forKey: key, value: value, table: tableName)
            }
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
