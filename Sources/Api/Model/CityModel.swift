import Foundation
import enum Decoder.Payload

public struct CityModel: Equatable {
  public let city:                    CityRecord
  public let location:                LocationRecord
  public let postal:                  PostalRecord
  public let subdivisions:            [SubdivisionRecord]
  public let continent:               ContinentRecord
  public let country:                 CountryRecord
  public let maxmind:                 MaxMindRecord
  public let registeredCountry:       CountryRecord
  public let representedCountry:      RepresentedCountryRecord
  public let traits:                  TraitsRecord
  public let ipAddress:               IpAddress
  public let netmask:                 IpAddress
  public var mostSpecificSubdivision: SubdivisionRecord { get { return subdivisions.last ?? SubdivisionRecord(nil) } }
}

extension CityModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      city: CityRecord(dictionary?["city"]?.unwrap()),
      location: LocationRecord(dictionary?["location"]?.unwrap()),
      postal: PostalRecord(dictionary?["postal"]?.unwrap()),
      subdivisions: (dictionary?["subdivisions"]?.unwrap() ?? [] as [Payload]).compactMap(
        { SubdivisionRecord($0.unwrap()) }
      ),
      continent: ContinentRecord(dictionary?["continent"]?.unwrap()),
      country: CountryRecord(dictionary?["country"]?.unwrap()),
      maxmind: MaxMindRecord(dictionary?["maxmind"]?.unwrap()),
      registeredCountry: CountryRecord(dictionary?["registered_country"]?.unwrap()),
      representedCountry: RepresentedCountryRecord(dictionary?["represented_country"]?.unwrap()),
      traits: TraitsRecord(dictionary?["traits"]?.unwrap()),
      ipAddress: ip,
      netmask: netmask
    )
  }
}