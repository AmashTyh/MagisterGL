#import "MSCMaterial.h"

@implementation MSCMaterial

- (instancetype)initWithNumberOfMaterial:(int)numberOfMaterial
                                   color:(SCNVector3)color
{
  self = [super init];
  if (self) {
    _numberOfMaterial = numberOfMaterial;
    _color = color;
  }
  return self;
}

@end
