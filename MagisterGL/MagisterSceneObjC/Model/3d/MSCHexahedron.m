#import "MSCHexahedron.h"

#import "MagisterGL-Swift.h"

@implementation MSCHexahedron

- (instancetype)initWithPositions:(NSArray *)positions
                       neighbours:(NSArray<NSArray<NSNumber *> *> *)neighbours
                         material:(int)material
                           colors:(NSArray *)colors
{
  self = [super init];
  if (self) {
    _positions = positions;
    _neighbours = neighbours;
    _material = material;
    _colors = colors;
    //_sidesArray = [NSArray array]; ADD THIS
    _sidesArray = [NSArray array];
    
  }
  return self;
}
- (void)generateSides
{
  // TODO: ADD THis
}
- (void)setColorToSides
{
   // TODO: ADD THis
}

@end

