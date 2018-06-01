//
//  MSCRnData.m
//  MagisterGL
//
//  Created by Admin on 02.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

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
