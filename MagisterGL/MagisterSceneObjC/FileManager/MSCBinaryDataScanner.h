#import <Foundation/Foundation.h>

@interface MSCBinaryDataScanner : NSObject

@property (nonatomic, strong) NSData* data;
@property (nonatomic) BOOL littleEndian;
@property (nonatomic) NSStringEncoding encoding;

- (instancetype)initWithData:(NSData *)data
                littleEndian:(BOOL)littleEndian
                    encoding:(NSStringEncoding)encoding;

- (double)readDouble;
- (int)readInt;

@end
