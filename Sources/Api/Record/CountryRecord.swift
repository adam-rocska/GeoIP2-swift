import Foundation

struct CountryRecord {
  // CONFIDENCE BEING AN INT?! ARE YOU FUCKING KIDDING ME! AND IT'S OPTIONAL.
  let confidence:        Int?
  let geonameId:         Int?
  // At least the bool isn't optional. Thank's php people. 👍 🖕
  let isInEuropeanUnion: Bool
  let isoCode:           String?
  let name:              String?
  let names:             [String: String]?
}
