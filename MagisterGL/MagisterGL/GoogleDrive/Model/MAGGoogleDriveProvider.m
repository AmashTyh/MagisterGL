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
       NSURL *filePath = [self localRandomURLforFileName: fileName];
       [file.data writeToURL: filePath
                  atomically: NO];
       
       NSString *filePathString = [[filePath.absoluteString componentsSeparatedByString: @"/"] lastObject];
       completion(YES, filePathString);
     }
     else
     {
       completion(NO, nil);
     }
   }];
}


#pragma mark - Private

- (NSURL *) localRandomURLforFileName: (NSString *) filename
{
  NSString *workDirectoryPath = [self workDirectory].path;
  while (YES)
  {
    NSString *fileName = [[NSString stringWithFormat: @"%u_", arc4random()] stringByAppendingString: filename];
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
