#import "MSCFileManager.h"

#import <SceneKit/SceneKit.h>
#import "MSCBinaryDataScanner.h"

@implementation MSCFileManager

- (NSArray *)getXYZArrayWithPath:(NSString *)path
{
  NSString* fileExtension = [NSURL URLWithString:path].pathExtension;
  if ([fileExtension isEqualToString:@"dat"]) {
    MSCBinaryDataScanner *scaner = [[MSCBinaryDataScanner alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path]
                                                                 littleEndian:true
                                                                     encoding:NSASCIIStringEncoding];
    NSMutableArray *arrayOfVectors = [NSMutableArray array];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    double value = [scaner readDouble];
    while (value) {
      [array addObject:[NSNumber numberWithDouble:value]];
      if (array.count == 3) {
        SCNVector3 vector = SCNVector3Make([array[0] floatValue],
                                           [array[1] floatValue],
                                           [array[2] floatValue]);
        [arrayOfVectors addObject:[NSValue valueWithSCNVector3:vector]];
      }
    }
    
    return [arrayOfVectors copy];
  }
  else {
    NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                            encoding:NSASCIIStringEncoding
                                                               error:nil];
    NSMutableArray *arrayOfVectors = [NSMutableArray array];
    
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
         NSArray<NSString *> *array = [string componentsSeparatedByString:@" "];
        if (array.count == 3) {
          SCNVector3 vector = SCNVector3Make([array[0] floatValue],
                                             [array[1] floatValue],
                                             [array[2] floatValue]);
          [arrayOfVectors addObject:[NSValue valueWithSCNVector3:vector]];
        }
      }
    }
    return [arrayOfVectors copy];
  }
}

- (NSArray<NSArray *> *)getNVERArrayWithPath:(NSString *)path
{
  NSString* fileExtension = [NSURL URLWithString:path].pathExtension;
  if ([fileExtension isEqualToString:@"dat"]) {
    MSCBinaryDataScanner *scaner = [[MSCBinaryDataScanner alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path]
                                                                 littleEndian:true
                                                                     encoding:NSASCIIStringEncoding];
    NSMutableArray<NSArray *> *arrayOfVectors = [NSMutableArray array];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    int value = [scaner readInt];
    while (value) {
      [array addObject:[NSNumber numberWithDouble:value]];
      if (array.count == 14) {
        [arrayOfVectors addObject:[array copy]];
        [array removeAllObjects];
      }
    }
    return [arrayOfVectors copy];
  }
  else {
    NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                            encoding:NSASCIIStringEncoding
                                                               error:nil];
    NSMutableArray<NSArray *> *arrayOfVectors = [NSMutableArray array];
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
        NSArray<NSString *> *strArray = [string componentsSeparatedByString:@" "];
        NSMutableArray<NSNumber *> *array = [NSMutableArray array];
        for (int i = 0; i < strArray.count; i++) {
          [array addObject:[NSNumber numberWithInt:[strArray[i] intValue]]];
        }
        [arrayOfVectors addObject:[array copy]];
      }
    }
    return [arrayOfVectors copy];
  }
}

- (NSArray<NSNumber *> *)getNVKATArrayWithPath:(NSString *)path
{
  NSString* fileExtension = [NSURL URLWithString:path].pathExtension;
  if ([fileExtension isEqualToString:@"dat"]) {
    MSCBinaryDataScanner *scaner = [[MSCBinaryDataScanner alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path]
                                                                 littleEndian:true
                                                                     encoding:NSASCIIStringEncoding];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    int value = [scaner readInt];
    while (value) {
      [array addObject: [NSNumber numberWithInt:value]];
    }
    return [array copy];
  }
  else {
    NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                            encoding:NSASCIIStringEncoding
                                                               error:nil];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
        int value = [[string componentsSeparatedByString:@"\r"][0] intValue];
        [array addObject:[NSNumber numberWithInt:value]];
      }
    }
    return [array copy];
  }
}

- (NSArray<NSArray *> *)getNEIBArrayWithPath:(NSString *)path
{
  NSString* fileExtension = [NSURL URLWithString:path].pathExtension;
  if ([fileExtension isEqualToString:@"dat"]) {
    MSCBinaryDataScanner *scaner = [[MSCBinaryDataScanner alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path]
                                                                 littleEndian:true
                                                                     encoding:NSASCIIStringEncoding];
    NSMutableArray<NSArray *> *arrayOfVectors = [NSMutableArray array];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    int value = [scaner readInt];
    while (value) {
      int arrayCount = value;
      if (arrayCount == 0) {
        [arrayOfVectors addObject:[@[[NSNumber numberWithInt:value]] copy]];
      }
      else if (arrayCount > 0) {
        [array addObject:[NSNumber numberWithInt:arrayCount]];
        int val = [scaner readInt];
        while (val) {
          [array addObject:[NSNumber numberWithInt: val]];
          if (array.count == arrayCount + 1) {
            [arrayOfVectors addObject:[array copy]];
            [array removeAllObjects];
            break;
          }
        }
      }
    }
    return [arrayOfVectors copy];
  }
  else {
    NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                            encoding:NSASCIIStringEncoding
                                                               error:nil];
    NSMutableArray<NSArray *> *arrayOfVectors = [NSMutableArray array];
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
        NSArray *array = [[[string componentsSeparatedByString:@"\r"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] componentsSeparatedByString:@" "];
        if (array.count == 1) {
          int value = [array[0] intValue];
          if (value == 0) {
            [arrayOfVectors addObject:@[@0]];
          }
        }
        else if (array.count > 1) {
          NSMutableArray<NSNumber *> *neibArray = [NSMutableArray array];
          int countOfNeib = [array[0] intValue];
          [neibArray addObject: [NSNumber numberWithInt:countOfNeib]];
          for (int index = 1; index <=countOfNeib; index++) {
            [neibArray addObject: [NSNumber numberWithInt:[array[index] intValue]]];
          }
          [arrayOfVectors addObject:[neibArray copy]];
        }
      
      }
    }
    return [arrayOfVectors copy];
  }
}

- (NSArray *)getSig3dArrayWithPath:(NSString *)path
{
  NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                          encoding:NSASCIIStringEncoding
                                                             error:nil];
  NSMutableArray<NSArray *> *arrayOfSig3d = [NSMutableArray array];
  for (NSString *string in [data componentsSeparatedByString:@"\n"]) {
    if (string.length != 0) {
      NSMutableArray<NSNumber *> *sig3dArray = [NSMutableArray array];
      NSArray *array = [[[string componentsSeparatedByString:@"\r"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] componentsSeparatedByString:@" "];
      for (NSString *elem in array) {
        if (elem.length != 0) {
          double doubleElem = [elem doubleValue];
          [sig3dArray addObject:[NSNumber numberWithDouble:doubleElem]];
        }
      }
      [arrayOfSig3d addObject: [sig3dArray copy]];
    }
  }
  return [arrayOfSig3d copy];
}

- (NSArray *)getProfileArrayWithPath:(NSString *)path
{
  NSMutableString *data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                          encoding:NSASCIIStringEncoding
                                                             error:nil];
  NSMutableArray *arrayOfVectors = [NSMutableArray array];
  
  for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
    if (string.length != 0) {
      NSArray<NSString *> *array = [string componentsSeparatedByString:@"\t"];
      if (array.count == 4) {
        SCNVector3 vector = SCNVector3Make([array[1] floatValue],
                                           [array[2] floatValue],
                                           [array[3] floatValue]);
        [arrayOfVectors addObject:[NSValue valueWithSCNVector3:vector]];
      }
    }
  }
  return [arrayOfVectors copy];
}

- (NSArray<NSDictionary<NSNumber *, NSNumber *> *> *)getEdsallArrayWithPath:(NSString *)path
{
  return @[@{}];
}
//func getEdsallArray(path: String) -> [[Float: Float]]
//{
//  var num: Int = 0
//  var result: [[Float: Float]] = []
//  do {
//    let data = try String(contentsOfFile: path,
//                          encoding: String.Encoding.ascii)
//    //var arrayOfVectors: [SCNVector3]? = []
//    var dictionaryOfReceiver: [Float: Float] = [:]
//    for string in data.components(separatedBy: "\n") {
//      if string != "" {
//        let array = string.components(separatedBy: "\t")
//        if array.count == 4 {
//          dictionaryOfReceiver[Float(array[0])!] = Float(array[3].components(separatedBy: "\r")[0])!
//        }
//        else {
//          if string.contains("element") {
//            if (num != 0) {
//              result.append(dictionaryOfReceiver)
//            }
//            num += 1
//          }
//        }
//      }
//    }
//    result.append(dictionaryOfReceiver)
//    return result
//
//  }
//  catch let err as NSError
//  {
//    print(err)
//  }
//  return []
//}

@end
