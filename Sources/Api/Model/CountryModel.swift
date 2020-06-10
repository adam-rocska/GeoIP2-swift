import Foundation
import enum Decoder.Payload

public struct CountryModel: Equatable {
  public let continent:          ContinentRecord
  public let country:            CountryRecord
  public let maxmind:            MaxMindRecord
  public let registeredCountry:  CountryRecord
  public let representedCountry: RepresentedCountryRecord
  public let traits:             TraitsRecord
  public let ipAddress:          IpAddress
  public let netmask:            IpAddress
}

extension CountryModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
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