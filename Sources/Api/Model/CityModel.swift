import Foundation
import enum Decoder.Payload

public struct CityModel {
  public let city:                    CityRecord
  public let location:                LocationRecord
  public let postal:                  PostalRecord
  public let subdivisions:            [SubdivisionRecord]
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
      ipAddress: ip,
      netmask: netmask
    )
  }
}