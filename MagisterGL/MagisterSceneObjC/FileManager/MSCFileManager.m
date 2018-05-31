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
    NSMutableArray<NSMutableArray *> *arrayOfVectors = [NSMutableArray array];
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
    NSMutableArray<NSMutableArray *> *arrayOfVectors = [NSMutableArray array];
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
        NSArray<NSString *> *strArray = [string componentsSeparatedByString:@" "];
        NSMutableArray<NSNumber *> *array = [NSMutableArray array];
        for (int i = 0; i < strArray.count; i++) {
          [array addObject:[NSNumber numberWithInt:[strArray[i] intValue]]];
        }
        [arrayOfVectors addObject:array];
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
    NSMutableArray<NSMutableArray *> *arrayOfVectors = [NSMutableArray array];
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
    NSMutableArray<NSMutableArray *> *arrayOfVectors = [NSMutableArray array];
    for (NSString* string in [data componentsSeparatedByString:@"\n"]) {
      if (string.length != 0) {
        NSArray *array = [[[string componentsSeparatedByString:@"\r"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] componentsSeparatedByString:@" "];
        if (array.count == 1) {
          int value = [array[0] intValue];
          if (value == 0) {
            [arrayOfVectors addObject:[@[@0] mutableCopy]];
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
  return @[@0];
}

- (NSArray *)getProfileArrayWithPath:(NSString *)path
{
  return @[@0];
}

@end
