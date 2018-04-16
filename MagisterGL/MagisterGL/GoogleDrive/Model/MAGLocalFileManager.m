//
//  MAGLocalFileManager.m
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import "MAGLocalFileManager.h"

@interface MAGLocalFileManager ()

@property (nonatomic, strong, readonly) NSMutableArray<NSString*> *filesnameArrayMutable;

@end

@implementation MAGLocalFileManager

- (instancetype)init
{
  self = [super init];
  if (self) {
    _filesnameArrayMutable = [NSMutableArray array];
  }
  return self;
}


- (NSArray<NSString*> *)getFilenamesArray
{
  return  [self.filesnameArrayMutable copy];
}

- (NSUInteger)findFilesInLocalDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  
  NSArray *contents = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:documentsPath]
                                 includingPropertiesForKeys:@[]
                                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                                      error:nil];
  for (NSURL *fileURL in contents) {
    NSLog(@"%@", fileURL.absoluteString);
    [self.filesnameArrayMutable addObject:fileURL.absoluteString];
  }
  return contents.count;
}

@end
