#import <Foundation/Foundation.h>

@interface MSCFileManager : NSObject

- (NSArray *)getXYZArrayWithPath:(NSString *)path;
- (NSArray *)getXYZValuesArrayWithPath:(NSString *)path;
- (NSArray *)getNVERArrayWithPath:(NSString *)path;
- (NSArray *)getNVKATArrayWithPath:(NSString *)path;
- (NSArray *)getNEIBArrayWithPath:(NSString *)path;
- (NSArray *)getSig3dArrayWithPath:(NSString *)path;
- (NSArray *)getProfileArrayWithPath:(NSString *)path;

@end
