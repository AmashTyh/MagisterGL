#import <Foundation/Foundation.h>

@interface MSCRnData : NSObject

@property (nonatomic) int numberOfTime;
@property (nonatomic) int numberOfProfileLine;
@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *>  *profileChartsData;

-(id)initWithNumberOfTime:(int)numberOfTime
      numberOfProfileLine:(int)numberOfProfileLine
        profileChartsData:(NSArray<NSArray<NSNumber *> *> *)profileChartsData;

@end

