#import "MSCCrossSection.h"

@implementation MSCCrossSection

- (instancetype)initWithPlane:(PlaneType)plane
                        value:(float)value
                      greater:(BOOL)greater
{
  self = [super init];
  if (self) {
    _plane = plane;
    _value = value;
    _greater = greater;
  }
  return self;
}

- (HexahedronVisible)isVisbleWithValue:(float)value
                              minValue:(float)minValue
                              maxValue:(float)maxValue
{
  if (self.greater) {
    if ((minValue <= value) && (value < maxValue))
    {
      if (value >= ((maxValue - minValue) / 2.0) + minValue)
      {
        return isVisible;
      }
      return notVisible;
    }
    else if (maxValue > value)
    {
      return notVisible;
    }
    return isVisible;
  }
  else {
    if ((minValue <= value) && (value < maxValue))
    {
      if (value < ((maxValue - minValue) / 2.0f) + minValue)
      {
        return isVisible;
      }
      return notVisible;
    }
    else if (maxValue < value)
    {
      return notVisible;
    }
    return isVisible;
  }
}

- (HexahedronVisible)setVisibleToHexahedronWithPositions:(NSArray *)positions
{
  NSArray *sortedArray = [positions sortedArrayUsingComparator:^NSComparisonResult(NSValue *v1, NSValue *v2) {
    SCNVector3 vector1 = [v1 SCNVector3Value];
    SCNVector3 vector2 = [v2 SCNVector3Value];
    switch (self.plane) {
      case X:
        return [[NSNumber numberWithFloat:vector1.x] compare:[NSNumber numberWithFloat:vector2.x]];
        break;
      case Y:
        return [[NSNumber numberWithFloat:vector1.y] compare:[NSNumber numberWithFloat:vector2.y]];
        break;
      case Z:
        return [[NSNumber numberWithFloat:vector1.z] compare:[NSNumber numberWithFloat:vector2.z]];
      default:
        break;
    }
  }];
  
  float minValue;
  float maxValue;
  switch (self.plane) {
    case X:
      minValue = [[sortedArray firstObject] SCNVector3Value].x;
      maxValue = [[sortedArray lastObject] SCNVector3Value].x;
      return [self isVisbleWithValue:self.value
                            minValue:minValue
                            maxValue:maxValue];
      break;
    case Y:
      minValue = [[sortedArray firstObject] SCNVector3Value].y;
      maxValue = [[sortedArray lastObject] SCNVector3Value].y;
      return [self isVisbleWithValue:self.value
                            minValue:minValue
                            maxValue:maxValue];
      break;
    case Z:
      minValue = [[sortedArray firstObject] SCNVector3Value].z;
      maxValue = [[sortedArray lastObject] SCNVector3Value].z;
      return [self isVisbleWithValue:self.value
                            minValue:minValue
                            maxValue:maxValue];
      break;
  }
}

@end


