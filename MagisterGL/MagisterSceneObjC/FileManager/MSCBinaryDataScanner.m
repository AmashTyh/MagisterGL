#import "MSCBinaryDataScanner.h"

@implementation MSCBinaryDataScanner

- (instancetype)initWithData: (NSData *)data
                littleEndian: (BOOL)littleEndian
                    encoding: (NSStringEncoding)encoding;
{
  self = [super init];
  if (self) {
    _data = data;
    _littleEndian = littleEndian;
    _encoding = encoding;
  }
  return self;
}

- (double)readDouble
{
  return  10.0;
}

- (int)readInt
{
  return 0;
}

@end
