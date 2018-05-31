//
//  MSCBinaryDataScanner.h
//  MagisterGL
//
//  Created by Admin on 27.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCBinaryDataScanner : NSObject

@property (nonatomic, strong) NSData* data;
@property (nonatomic) BOOL littleEndian;
@property (nonatomic) NSStringEncoding encoding;

- (instancetype)initWithData: (NSData *)data
                littleEndian: (BOOL)littleEndian
                    encoding: (NSStringEncoding)encoding;

- (double)readDouble;
- (int)readInt;

@end
