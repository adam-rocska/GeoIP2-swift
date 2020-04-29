//
// Created by Rocska Ádám on 2020. 04. 28..
//

import Foundation

public protocol City {
  var confidence: UInt8 { get }
  var geonameId:  UInt { get }
  var name:       String { get }
  var names:      [String: String] { get }
}
