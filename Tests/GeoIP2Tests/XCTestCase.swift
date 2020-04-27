import Foundation
import XCTest

extension XCTestCase {

  var bundle: Bundle {
    get {
      guard let currentFileUrl = URL(string: #file) else {
        return Bundle.main
      }

      guard let testBundle = Bundle(path: currentFileUrl.deletingLastPathComponent().path) else {
        return Bundle.main
      }

      return testBundle
    }
  }

}
