import Foundation
import enum Decoder.Payload

public struct LocationRecord {
  // assumed
  let averageIncome:     UInt32?
  let accuracyRadius:    UInt16?
  let latitude:          Double?
  let longitude:         Double?
  // assumed
  let populationDensity: UInt16?
  // assumed
  let metroCode:         UInt16?
  let timeZone:          String?

  public init(
    averageIncome: UInt32?,
    accuracyRadius: UInt16?,
    latitude: Double?,
    longitude: Double?,
    populationDensity: UInt16?,
    metroCode: UInt16?,
    timeZone: String?
  ) {
    self.averageIncome = averageIncome
    self.accuracyRadius = accuracyRadius
    self.latitude = latitude
    self.longitude = longitude
    self.populationDensity = populationDensity
    self.metroCode = metroCode
    self.timeZone = timeZone
  }

  init(_ dictionary: [String: Payload]?) {
    self.init(
      averageIncome: dictionary?["average_income"]?.unwrap(),
      accuracyRadius: dictionary?["accuracy_radius"]?.unwrap(),
      latitude: dictionary?["latitude"]?.unwrap(),
      longitude: dictionary?["longitude"]?.unwrap(),
      populationDensity: dictionary?["population_density"]?.unwrap(),
      metroCode: dictionary?["metro_code"]?.unwrap(),
      timeZone: dictionary?["time_zone"]?.unwrap()
    )
  }
}
