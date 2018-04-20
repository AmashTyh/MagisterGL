//
//  MAGLocalFileManager.h
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAGLocalFileManager : NSObject

@property (nonnull, nonatomic, strong) NSFileManager *fileManager;
@property (nonnull, nonatomic, strong, readonly, getter=getFilenamesArray) NSArray<NSString*> *filesnameArray;

- (NSUInteger) findFilesInLocalDirectory;

@end
