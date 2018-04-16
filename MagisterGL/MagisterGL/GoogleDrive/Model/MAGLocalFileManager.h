//
//  MAGLocalFileManager.h
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGLocalFileManager : NSObject

@property (nonatomic, strong, readonly, getter=getFilenamesArray) NSArray<NSString*> *filesnameArray;

- (NSArray<NSString*> *)getFilenamesArray;
- (NSUInteger)findFilesInLocalDirectory;

@end
