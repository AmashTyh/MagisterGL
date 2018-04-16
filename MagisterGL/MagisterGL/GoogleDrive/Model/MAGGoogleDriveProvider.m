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

//+ (GoogleDriveProvider*)sharedInstance
//{
//    if (sharedInstance_ == nil) {
//        sharedInstance_ = [[GoogleDriveProvider alloc] init];
//        sharedInstance_.service = [[GTLRDriveService alloc] init];
//        sharedInstance_.filesDictionary = [NSDictionary dictionary];
//    }
//    return sharedInstance_;
//}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _service = [[GTLRDriveService alloc] init];
    _filesDictionary = [NSDictionary dictionary];
  }
  return self;
}

- (void)listFilesWithCompletionBlock:(void (^)(BOOL success))completion
{
  self.mutFilesDictionary = [NSMutableDictionary dictionary];
  self.service.shouldFetchNextPages = YES;
  GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
  query.fields = @"nextPageToken, files(id, name)";
  
  [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRDrive_FileList *result, NSError *error) {
    if (error == nil) {
      
      if (result.files.count > 0) {
        int count = 1;
        for (GTLRDrive_File *file in result.files) {
          self.mutFilesDictionary[file.name] = file.identifier;
          count++;
        }
        self.filesDictionary = [self.mutFilesDictionary copy];
        completion(YES);
      }
    } else {
      NSLog(@"Something strange");
      completion(NO);
    }
  }];
}

- (void)downloadFileWithFileID: (NSString*)fileID fileName: (NSString*)fileName completionBlock:(void (^)(BOOL result))completion
{
  GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:fileID];
  [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
                                                       GTLRDataObject *file,
                                                       NSError *error) {
    if (error == nil) {
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSURL *documentsPath = [fileManager URLForDirectory:NSDocumentDirectory
                                                 inDomain:NSUserDomainMask
                                        appropriateForURL:nil
                                                   create:NO
                                                    error:nil];
      NSURL *filePath = [documentsPath URLByAppendingPathComponent:fileName];
      BOOL fileExists = [fileManager fileExistsAtPath:filePath.absoluteString];
      if (fileExists == NO) {
        [file.data writeToURL:filePath atomically:NO];
        NSLog(@"Downloaded %lu bytes", file.data.length);
      } else {
        NSLog(@"File already exist");
      }
      completion(YES);
    } else {
      NSLog(@"An error occurred: %@", error);
      completion(NO);
    }
  }];
}

@end
