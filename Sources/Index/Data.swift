import Foundation

extension Data {

  func chunked(into size: Int) -> [Data] {
    precondition(size > 0, "Can't chunk data into 0 sized chunks.")
    precondition(size <= count, "Can't chunk data into chunks of greater size.")
    precondition(count % size == 0, "Data is not divisible into \(size)sized chunks.")
    var bounds         = (
      lower: startIndex,
      upper: index(startIndex, offsetBy: size, limitedBy: endIndex) ?? endIndex
    )
    var result: [Data] = []
    while bounds.lower != endIndex {
      result.append(subdata(in: Range(uncheckedBounds: bounds)))
      bounds = (
        lower: bounds.upper,
        upper: index(bounds.upper, offsetBy: size, limitedBy: endIndex) ?? endIndex
      )
    }
    return result
  }

}
