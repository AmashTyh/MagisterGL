//
//  MAGGoogleDriveProvider.m
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import "MAGGoogleDriveProvider.h"

@interface MAGGoogleDriveProvider ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSString*>* mutFilesDictionary;

@end

@implementation MAGGoogleDriveProvider

- (instancetype) init
{
  self = [super init];
  if (self)
  {
    _fileManager = [NSFileManager defaultManager];
    _service = [[GTLRDriveService alloc] init];
    _filesDictionary = [NSDictionary dictionary];
  }
  return self;
}

- (void) listFilesWithCompletionBlock: (void (^)(BOOL success)) completion
{
  self.mutFilesDictionary = [NSMutableDictionary dictionary];
  self.service.shouldFetchNextPages = YES;
  GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
  query.fields = @"nextPageToken, files(id, name)";
  
  [self.service executeQuery: query
           completionHandler: ^(GTLRServiceTicket *ticket,
                                GTLRDrive_FileList *result,
                                NSError *error)
   {
     if (error == nil)
     {
       if (result.files.count > 0)
       {
         int count = 1;
         for (GTLRDrive_File *file in result.files)
         {
           self.mutFilesDictionary[file.name] = file.identifier;
           count++;
         }
         self.filesDictionary = [self.mutFilesDictionary copy];
         completion(YES);
       }
     }
     else
     {
       NSLog(@"Something strange");
       completion(NO);
     }
   }];
}

- (void) downloadFileWithFileID: (NSString *) fileID
                       fileName: (NSString *) fileName
                completionBlock: (void (^) (BOOL result, NSString * filePath)) completion
{
  GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId: fileID];
  [self.service executeQuery: query
           completionHandler: ^(GTLRServiceTicket *ticket,
                                GTLRDataObject *file,
                                NSError *error)
   {
     if (error == nil)
     {
       NSString *fileType = @"";
       NSString *lastPath = [[fileName componentsSeparatedByString: @"."] lastObject];
       if ([lastPath isEqualToString: @"txt"] ||
           [lastPath isEqualToString: @"dat"])
       {
         fileType = lastPath;
       }
       NSURL *filePath = [self localRandomURLforFileWithType: fileType];
       [file.data writeToURL: filePath
                  atomically: NO];
       NSLog(@"Downloaded %lu bytes", file.data.length);
       
       NSString *filePathString = [[filePath.absoluteString componentsSeparatedByString: @"/"] lastObject];
       completion(YES, filePathString);
     }
     else
     {
       NSLog(@"An error occurred: %@", error);
       completion(NO, nil);
     }
   }];
}


#pragma mark - Private

- (NSURL *) localRandomURLforFileWithType: (NSString *) type
{
  NSString *workDirectoryPath = [self workDirectory].path;
  while (YES)
  {
    NSString *fileName = [[NSString stringWithFormat: @"file_%u.", arc4random()] stringByAppendingString: type];
    NSString *path = [workDirectoryPath stringByAppendingPathComponent: fileName];
    
    if (![self.fileManager fileExistsAtPath: path])
    {
      return [NSURL fileURLWithPath: path];
    }
  }
}

- (NSURL *) workDirectory
{
  NSArray <NSURL *> *urls = [self.fileManager URLsForDirectory: NSDocumentDirectory
                                                     inDomains: NSUserDomainMask];
  return urls.firstObject;
}

@end
