#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface MSCMaterial : NSObject

@property(nonatomic, readonly) int numberOfMaterial;
@property(nonatomic, readonly) SCNVector3 color;

- (instancetype)initWithNumberOfMaterial:(int)numberOfMaterial
                                   color:(SCNVector3)color;
@end
