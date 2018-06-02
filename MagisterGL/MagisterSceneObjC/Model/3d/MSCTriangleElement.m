#import "MSCTriangleElement.h"

@implementation MSCTriangleElement

- (instancetype)initWithPositions:(NSArray *)positions
                           colors:(NSArray *)colors
{
  self = [super init];
  if (self) {
    _positions = positions;
    _colors = colors;
  }
  return self;
}

- (NSArray<NSNumber *> *)indicesArrayWithAddValue:(int)addValue
{
  return @[[NSNumber numberWithInt: 0 + addValue], [NSNumber numberWithInt: 1 + addValue], [NSNumber numberWithInt: 2 + addValue]];
}

@end

