#import "MSCRnData.h"

@implementation MSCRnData

-(id)initWithNumberOfTime:(int)numberOfTime
      numberOfProfileLine:(int)numberOfProfileLine
        profileChartsData:(NSArray<NSArray<NSNumber *> *> *)profileChartsData
{
  self = [super init];
  if (self) {
    _numberOfTime = numberOfTime;
    _numberOfProfileLine = numberOfProfileLine;
    _profileChartsData = profileChartsData;
  }
  return self;
}

@end
