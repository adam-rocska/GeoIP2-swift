import Foundation

func interpretUtf8String(bytes: Data) -> Payload? {
  guard let string = String(bytes) else { return nil }
  return Payload.utf8String(string)
}