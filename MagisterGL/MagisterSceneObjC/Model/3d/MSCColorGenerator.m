#import "MSCColorGenerator.h"
#import "Color.h"

@interface MSCColorGenerator ()

@property (nonatomic, strong) NSMutableArray<Color *> *mRainbow;

@end

@implementation MSCColorGenerator

- (instancetype)init
{
  self = [super init];
  if (self) {
    _kCountOfColorAreas = 40;
    _rainbow = [NSArray array];
  }
  return self;
}

- (void)generateColorWithMinValue:(double)minValue
                        maxValue:(double)maxValue
{
  double hValues = (maxValue - minValue) / (self.kCountOfColorAreas - 1);
  for (int i = 0; i < self.kCountOfColorAreas; i++) {
    Color *color = [[Color alloc] init];
    color.value = minValue + i * hValues;
    [self.mRainbow addObject:color];
  }
  double colorRedMin = 0;
  double colorGreenMin = 5;
  double colorBlueMin = 255;
  
  double colorRedMax = 0;
  double colorGreenMax = 255;
  double colorBlueMax = 25;
  
  self.mRainbow[self.kCountOfColorAreas -1].red = colorRedMax;
  self.mRainbow[self.kCountOfColorAreas -1].green = colorGreenMax;
  self.mRainbow[self.kCountOfColorAreas -1].blue = colorBlueMax;
  
  double colorRedH = (colorRedMax - colorRedMin) / (self.kCountOfColorAreas - 1);
  double colorGreenH = (colorGreenMax - colorGreenMin) / (self.kCountOfColorAreas - 1);
  double colorBlueH = (colorBlueMax - colorBlueMin) / (self.kCountOfColorAreas - 1);
 
  for (int i=0; i<self.kCountOfColorAreas; i++) {
    self.mRainbow[i].red = colorRedMin + i * colorRedH;
    self.mRainbow[i].green = colorGreenMin + i * colorGreenH;
    self.mRainbow[i].blue = colorBlueMin + i * colorBlueH;
  }
  
  self.rainbow = [self.mRainbow copy];
}

- (SCNVector3)getColorForU:(double)u
{
  int i = 0;
  while (i < self.kCountOfColorAreas - 1 && u >= self.rainbow[i + 1].value) {
    i++;
  }
  return self.rainbow[i].colorVector;
}

- (NSArray *)getColorForValues: (NSArray *)values
{
  NSMutableArray *colors = [NSMutableArray array];
  for (NSNumber *uValue in values) {
    double u = (double)[uValue floatValue];
    int i = 0;
    while (i < self.kCountOfColorAreas - 1 && u >= self.rainbow[i + 1].value) {
      i++;
    }
    [colors addObject:[NSValue valueWithSCNVector3:self.rainbow[i].colorVector]];
  }
  return [colors copy];
}

@end
