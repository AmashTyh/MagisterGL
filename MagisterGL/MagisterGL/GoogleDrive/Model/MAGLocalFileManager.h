#import <Foundation/Foundation.h>

@interface MAGLocalFileManager : NSObject

@property (nonnull, nonatomic, strong) NSFileManager *fileManager;
@property (nonnull, nonatomic, strong, readonly, getter=getFilenamesArray) NSArray<NSString*> *filesnameArray;

- (NSUInteger) findFilesInLocalDirectory;

@end
