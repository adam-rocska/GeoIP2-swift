import Foundation
import enum Decoder.Payload

public struct CityModel {
  let city:                    CityRecord
  let location:                LocationRecord
  let postal:                  PostalRecord
  let subdivisions:            [SubdivisionRecord]
  var mostSpecificSubdivision: SubdivisionRecord {
    get {
      return subdivisions.last ?? SubdivisionRecord(nil)
    }
  }

  public init(
    city: CityRecord,
    location: LocationRecord,
    postal: PostalRecord,
    subdivisions: [SubdivisionRecord]
  ) {
    self.city = city
    self.location = location
    self.postal = postal
    self.subdivisions = subdivisions
  }

  init(_ dictionary: [String: Payload]?) {
    self.init(
      city: CityRecord(dictionary?["city"]?.unwrap()),
      location: LocationRecord(dictionary?["location"]?.unwrap()),
      postal: PostalRecord(dictionary?["postal"]?.unwrap()),
      subdivisions: (dictionary?["subdivisions"]?.unwrap() ?? [] as [Payload]).compactMap(
        { SubdivisionRecord($0.unwrap()) }
      )
    )
  }
}
