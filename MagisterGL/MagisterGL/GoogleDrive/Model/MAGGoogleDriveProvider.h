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

@property (nonatomic, strong) GTLRDriveService* service;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*>* filesDictionary;

//+ (GoogleDriveProvider*)sharedInstance;

- (void)listFilesWithCompletionBlock:(void (^)(BOOL success))completion;
- (void)downloadFileWithFileID: (NSString*)fileID fileName: (NSString*)fileName completionBlock:(void (^)(BOOL result))completion;

@end
