#import <Foundation/Foundation.h>

@interface MSCFileManager : NSObject

- (NSArray *)getXYZArrayWithPath:(NSString *)path;
- (NSArray<NSArray *> *)getNVERArrayWithPath:(NSString *)path;
- (NSArray<NSNumber *> *)getNVKATArrayWithPath:(NSString *)path;
- (NSArray<NSArray *> *)getNEIBArrayWithPath:(NSString *)path;
- (NSArray *)getSig3dArrayWithPath:(NSString *)path;
- (NSArray *)getProfileArrayWithPath:(NSString *)path;

@end
