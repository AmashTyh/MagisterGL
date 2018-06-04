import UIKit

/**
 модуль для чтения бинарных файлов.
 Занимается преобразование бинарных данных
 и возвращает в необходимом формате, например целые числа.
 */
protocol MAGBinaryReadable
{
  var littleEndian: Self { get }
  var bigEndian: Self { get }
}
extension UInt8: MAGBinaryReadable
{
  var littleEndian: UInt8 { return self }
  var bigEndian: UInt8 { return self }
}
extension UInt16: MAGBinaryReadable {}
extension UInt32: MAGBinaryReadable {}
extension UInt64: MAGBinaryReadable {}
extension Float32: MAGBinaryReadable
{
  var littleEndian: Float32 { return self }
  var bigEndian: Float32 { return self }
}
extension Float64: MAGBinaryReadable
{
  var littleEndian: Float64 { return self }
  var bigEndian: Float64 { return self  }
}


class MAGBinaryDataScanner: NSObject {
  
  let data: NSData
  let littleEndian: Bool
  let encoding: String.Encoding
  
  var current: UnsafeRawPointer
  var remaining: Int
  
  init(data: NSData, littleEndian: Bool, encoding: String.Encoding) {
    self.data = data
    self.littleEndian = littleEndian
    self.encoding = encoding
    
    self.current = self.data.bytes
    self.remaining = self.data.length
  }
  
  func read<T: MAGBinaryReadable>() -> T? {
    if remaining < MemoryLayout<T>.size {
      return nil
    }
    
    let tCurrent: UnsafePointer = current.assumingMemoryBound(to: T.self)
    let v = tCurrent.pointee
    current = UnsafeRawPointer(tCurrent.successor())
    remaining -= MemoryLayout<T>.size
    return littleEndian ? v.littleEndian : v.bigEndian
  }
  
  /* convenience read funcs */
  
  func readByte() -> UInt8? {
    return read()
  }
  
  func read16() -> UInt16? {
    return read()
  }
  
  func read32() -> UInt32? {
    return read()
  }
  
  func read64() -> UInt64? {
    return read()
  }
  
  func readFloat() -> Float32? {
    return read()
  }
  
  func readDouble() -> Float64? {
    return read()
  }

  
  func readNullTerminatedString() -> String? {
    var string:String? = nil
    var tCurrent: UnsafePointer = current.assumingMemoryBound(to: UInt8.self)
    var count: Int = 0
    
    // scan
    while (remaining > 0 && tCurrent.pointee != 0) {
      remaining -= 1
      count += 1
      tCurrent = tCurrent.successor()
    }
    
    // create string if available
    if (remaining > 0 && tCurrent.pointee == 0) {
      string = NSString(bytes: current,
                        length: count,
                        encoding: encoding.rawValue)! as String
      current = UnsafeRawPointer(tCurrent.successor())
      remaining -= 1
    }
    
    return string
  }
}
