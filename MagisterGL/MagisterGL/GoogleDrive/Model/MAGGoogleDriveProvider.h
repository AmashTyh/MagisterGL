//
//  MAGGoogleDriveProvider.h
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import GoogleSignIn;
#import <GoogleAPIClientForREST/GTLRDrive.h>


@interface MAGGoogleDriveProvider : NSObject

@property (nonnull, nonatomic, strong) NSFileManager *fileManager;
@property (nonnull, nonatomic, strong) GTLRDriveService *service;
@property (nonnull, nonatomic, strong) NSDictionary<NSString *, NSString *> *filesDictionary;

//+ (GoogleDriveProvider*)sharedInstance;

- (void) listFilesWithCompletionBlock:(void (^_Nullable)(BOOL success))completion;
- (void) downloadFileWithFileID: (nonnull NSString *) fileID
                       fileName: (nonnull NSString *) fileName
                completionBlock: (void (^_Nonnull)(BOOL result, NSString * _Nullable filePath)) completion;

@end
