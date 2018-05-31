//
//  MAGLocalFileManager.m
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


#import "MAGLocalFileManager.h"


@interface MAGLocalFileManager ()

@property (nonatomic, strong) NSMutableArray <NSString*> *filesnameArrayMutable;

@end


@implementation MAGLocalFileManager

- (instancetype) init
{
  self = [super init];
  if (self)
  {
    _fileManager = [NSFileManager defaultManager];
    _filesnameArrayMutable = [NSMutableArray array];
  }
  return self;
}


- (NSArray <NSString*> *) getFilenamesArray
{
  return [self.filesnameArrayMutable copy];
}

- (NSUInteger) findFilesInLocalDirectory
{
  self.filesnameArrayMutable = [NSMutableArray array];
  NSURL *workDirectory = [self workDirectory];
  NSError *error = nil;
  NSArray <NSURL *> *contents = [self.fileManager contentsOfDirectoryAtURL: workDirectory
                                                includingPropertiesForKeys: nil
                                                                   options: 0
                                                                     error: &error];
  for (NSURL *fileURL in contents)
  {
    [self.filesnameArrayMutable addObject: fileURL.absoluteString];
  }
  return contents.count;
}

- (void) removeFileWithIndex: (NSUInteger) index
{
  NSString *fileName = [self.filesnameArrayMutable objectAtIndex: index];
  NSError *error = nil;
  [self.fileManager removeItemAtURL: [NSURL URLWithString: fileName]
                              error: &error];
  NSLog(@"%@", error);
}

- (NSURL *) workDirectory
{
  NSArray <NSURL *> *urls = [self.fileManager URLsForDirectory: NSDocumentDirectory
                                                     inDomains: NSUserDomainMask];
  return urls.firstObject;
}

@end
