import Foundation

extension Data {

  func chunked(into size: Int) -> [Data] {
    precondition(size > 0, "Can't chunk data into 0 sized chunks.")
    precondition(count % size == 0, "Data is not divisible into \(size)sized chunks.")
    if count <= size { return [self] }
    var bounds         = (lower: startIndex, upper: index(startIndex, offsetBy: size))
    var result: [Data] = []
    while bounds.lower != endIndex {
      result.append(subdata(in: Range(uncheckedBounds: bounds)))
      bounds = (lower: bounds.upper, upper: index(bounds.upper, offsetBy: size))
    }
    return result
  }

}
