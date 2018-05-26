#import "MSCFileManager.h"

#import <SceneKit/SceneKit.h>
//#import "MAGBinaryDataScanner-Swift.h"

@implementation MSCFileManager

- (NSArray *)getXYZArrayWithPath:(NSString *)path
{
  NSString* fileExtension = [NSURL URLWithString:path].pathExtension;//URL(fileURLWithPath: path).pathExtension
  if ([fileExtension isEqualToString:@"dat"]) {
//    let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
//                                          littleEndian: true,
//                                          encoding: String.Encoding.ascii)
//    var arrayOfVectors: [SCNVector3]? = []
//    var array: [Float64]? = []
//    while let value = scaner.readDouble()
//    {
//      array?.append(value)
//      if array?.count == 3
//      {
//        let vector = SCNVector3Make(Float(array![0]),
//                                    Float(array![1]),
//                                    Float(array![2]))
//        arrayOfVectors?.append(vector)
//        array = []
//      }
//    }
//    return arrayOfVectors!
    return @[];
  }
  else {
    NSMutableString* data = [NSMutableString stringWithContentsOfURL:[NSURL URLWithString:path]
                                                            encoding:NSASCIIStringEncoding//NSUTF8StringEncoding
                                                               error:nil];
    
    //var arrayOfVectors: [SCNVector3]? = []
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

- (NSArray *)getXYZValuesArrayWithPath:(NSString *)path
{
  return @[@0];
}
- (NSArray *)getNVERArrayWithPath:(NSString *)path
{
  return @[@0];
}

- (NSArray *)getNVKATArrayWithPath:(NSString *)path
{
  return @[@0];
}

- (NSArray *)getNEIBArrayWithPath:(NSString *)path
{
  return @[@0];
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
