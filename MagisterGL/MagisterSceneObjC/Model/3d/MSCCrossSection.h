#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

#import "MSCHexahedron.h"

typedef NS_ENUM(NSUInteger, PlaneType) {
  X,
  Y,
  Z,
};

@interface MSCCrossSection : NSObject

@property(nonatomic) PlaneType plane;
@property(nonatomic) float value;
@property(nonatomic) BOOL greater;

- (instancetype)initWithPlane:(PlaneType)plane
                        value:(float)value
                      greater:(BOOL)greater;

- (HexahedronVisible)isVisbleWithValue:(float)value
                              minValue:(float)minValue
                              maxValue:(float)maxValue;

- (HexahedronVisible)setVisibleToHexahedronWithPositions:(NSArray *)positions;

@end
