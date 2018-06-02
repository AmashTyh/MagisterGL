#import "Color.h"

@implementation Color

- (instancetype)init
{
  self = [super init];
  if (self) {
    _red = 0.0;
    _green = 0.0;
    _blue = 0.0;
    _value = 0.0;
  }
  return self;
}

- (UIColor *)getColor
{
  return [UIColor colorWithRed:(CGFloat)(self.red/255.0)
                         green:(CGFloat)(self.green/255.0)
                          blue:(CGFloat)(self.blue/255.0)
                         alpha:1.0f];
}

- (SCNVector3)getColorVector
{
  return SCNVector3Make((float)(self.red/255.0),
                        (float)(self.green/255.0),
                        (float)(self.blue/255.0));
}

@end
