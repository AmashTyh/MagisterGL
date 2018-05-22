#import "MAGcFileManager.h"

#import <SceneKit/SceneKit.h>

@implementation MAGcFileManager

- (void)test
{
  SCNVector3 vector = SCNVector3Make(1, 2, 3);
  self.xyzArray = [NSMutableArray array];
  [self.xyzArray addObject:[NSValue valueWithSCNVector3:vector]];

  SCNVector3 res =  [self.xyzArray[0] SCNVector3Value];
}

@end
