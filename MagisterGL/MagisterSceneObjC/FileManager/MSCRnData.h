//
//  MSCRnData.h
//  MagisterGL
//
//  Created by Admin on 02.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCRnData : NSObject

@property (nonatomic) int numberOfTime;
@property (nonatomic) int numberOfProfileLine;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *>  *profileChartsData;

-(id)initWithNumberOfTime:(int)numberOfTime
      numberOfProfileLine:(int)numberOfProfileLine
        profileChartsData:(NSArray<NSArray<NSNumber *> *> *)profileChartsData;

@end

