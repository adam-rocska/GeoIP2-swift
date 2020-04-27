import Foundation

struct Country: CountryProtocol {
  let continent: ContinentProtocol?
  let isoCode:   String?
  let names:     [String: String]?

  init(dictionary: NSDictionary) {
    if let dict = dictionary["continent"] as? NSDictionary,
       let code = dict["code"] as? String,
       let continentNames = dict["names"] as? [String: String] {
      continent = Continent(code: code, names: continentNames)
    } else {
      continent = nil
    }
    if let dict = dictionary["country"] as? NSDictionary,
       let iso = dict["iso_code"] as? String,
       let countryNames = dict["names"] as? [String: String] {
      isoCode = iso
      names = countryNames
    } else {
      isoCode = nil
      names = nil
    }
  }

}

public protocol CountryProtocol {
  var continent: ContinentProtocol? { get }
  var isoCode:   String? { get }
  var names:     [String: String]? { get }
}