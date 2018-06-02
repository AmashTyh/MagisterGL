#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <SceneKit/SceneKit.h>

@interface MSCTriangleElement : NSObject

@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, strong) NSArray *positions;

- (instancetype)initWithPositions:(NSArray *)positions
                           colors:(NSArray *)colors;

- (NSArray<NSNumber *> *)indicesArrayWithAddValue:(int)addValue;

@end


