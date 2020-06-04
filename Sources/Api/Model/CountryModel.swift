import Foundation
import enum Decoder.Payload

public struct CountryModel {
  let continent:          ContinentRecord
  let country:            CountryRecord
  let maxmind:            MaxMindRecord
  let registeredCountry:  CountryRecord
  let representedCountry: RepresentedCountryRecord
  let traits:             TraitsRecord
}

extension CountryModel: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      continent: ContinentRecord(dictionary?["continent"]?.unwrap()),
      country: CountryRecord(dictionary?["country"]?.unwrap()),
      maxmind: MaxMindRecord(dictionary?["maxmind"]?.unwrap()),
      registeredCountry: CountryRecord(dictionary?["registered_country"]?.unwrap()),
      representedCountry: RepresentedCountryRecord(dictionary?["represented_country"]?.unwrap()),
      traits: TraitsRecord(dictionary?["traits"]?.unwrap())
    )
  }


}