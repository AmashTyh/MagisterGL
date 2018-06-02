#import "MSCCustomGeometryModel.h"

#import "MagisterGL-Swift.h"

#import "MSCFileManager.h"
#import "MSCColorGenerator.h"
#import "MSCMaterial.h"

@interface MSCCustomGeometryModel ()

@property (nonatomic, strong) NSMutableArray<MSCHexahedron *> *mElementsArray;
@property (nonatomic, strong) NSMutableArray<MSCMaterial *> *mMaterials;
@property (nonatomic, strong) NSMutableArray<MSCMaterial *> *mSelectedMaterials;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *mTimeSlices;
@property (nonatomic, strong) NSMutableArray<MSCTriangleElement *> *mReceiversSurface;
@property (nonatomic, strong) NSMutableArray *mTimeSlicesForCharts;
@property (nonatomic, strong) NSMutableArray<NSArray *> *mFieldsArray;

@property (nonatomic, strong) NSMutableArray *mRnArray;

@end

@implementation MSCCustomGeometryModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    _fileManager = [[MSCFileManager alloc] init];
    _isShowMaterial = YES;
    _showFieldNumber = 0;
    _showTimeSliceNumber = 0;
    _showTimeSliceForCharts = 0;
    _scaleValue = 1.0f;
    _isDrawingSectionEnabled = NO;
    _mElementsArray = [NSMutableArray array];
    _centerPoint = SCNVector3Make(0, 0, 0);
    _minVector = SCNVector3Make(0, 0, 0);
    _maxVector = SCNVector3Make(0, 0, 0);
    _xyzArray = [NSArray array];
    _fieldsArray = [NSArray array];
    _nverArray = [NSArray array];
    _nvkatArray = [NSArray array];
    _neibArray = [NSArray array];
    _sectionValue = 0;
    _greater = YES;
    _mMaterials = [NSMutableArray array];
    _mSelectedMaterials = [NSMutableArray array];
    _sig3dArray = [NSArray array];
    _profileArray = [NSArray array];
    _edsallArray = [NSArray array];
    _rnArray = [NSArray array];
    _mRnArray = [NSMutableArray array];
  }
  return self;
}

- (void)configureWithProject:(MAGProject *)project
{
  self.project = project;
  NSString *docDirectory = [NSString string];
  if (project.isLocal == NO) {
    docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    docDirectory = [docDirectory stringByAppendingString:@"/"];
  }
 
  NSString *documentsPath = project.isLocal ? [[NSBundle mainBundle] resourcePath] : docDirectory;
  self.xyzArray = [self.fileManager getXYZArrayWithPath:[documentsPath stringByAppendingString:project.xyzFilePath]];
  self.nverArray = [self.fileManager getNVERArrayWithPath:[documentsPath stringByAppendingString:project.nverFilePath]];
  self.nvkatArray = [self.fileManager getNVKATArrayWithPath:[documentsPath stringByAppendingString:project.nvkatFilePath]];
  self.sig3dArray = [self.fileManager getSig3dArrayWithPath:[documentsPath stringByAppendingString:project.sigma3dPath]];
  self.profileArray = [self.fileManager getProfileArrayWithPath:[documentsPath stringByAppendingString:project.profilePath]];
  self.edsallArray = [self.fileManager getEdsallArrayWithPath:[documentsPath stringByAppendingString:project.edsallPath]];
  if (self.edsallArray.count > 0) {
    for (NSNumber *key in [self.edsallArray[0] allKeys]) {
      [self.mTimeSlices addObject:key];
    }
    self.timeSlices = [[self.mTimeSlices sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
      NSNumber *first = (NSNumber *)a;
      NSNumber *second = (NSNumber *)b;
      return [first compare:second];
    }] copy];
  }
  NSArray<NSString *> *decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData: project.rnArrayPathsArray];
  for (NSString *rnArrayFilePath in decodedArray) {
    MSCRnData *rnTmpData = [self.fileManager getRnArrayWithPath:[documentsPath stringByAppendingString:rnArrayFilePath]];
    [self.mRnArray addObject:rnTmpData];
  }

  if (self.sig3dArray.count > 0) {
    NSMutableArray<NSArray<NSNumber *> *> *mSigma3dArray = [self.sig3dArray mutableCopy];
    mSigma3dArray = [[mSigma3dArray sortedArrayUsingComparator:^NSComparisonResult(id  a, id  b) {
      NSArray<NSNumber *> *first = (NSArray<NSNumber *> *)a;
      NSArray<NSNumber *> *second = (NSArray<NSNumber *> *)b;
      return [first[1] compare:second[1]];
    }] mutableCopy];
    
    float min = [[mSigma3dArray firstObject][1] floatValue];
    float max = [[mSigma3dArray lastObject][1] floatValue];
    
    MSCColorGenerator *colorGenerator = [[MSCColorGenerator alloc] init];
    
    [colorGenerator generateColorWithMinValue: min
                                     maxValue: max];
    self.colorGenerator = colorGenerator;
    
    for (int i = 0; i < self.sig3dArray.count; i++) {
      int materialNumber = [self.sig3dArray[i][0] intValue];
      SCNVector3 vector = [self.colorGenerator getColorForU: [self.sig3dArray[i][1] floatValue]];
      MSCMaterial *material = [[MSCMaterial alloc] initWithNumberOfMaterial: materialNumber
                                                                      color: vector];
      [self.mMaterials addObject:material];
    }
  }
  else  {
    NSMutableSet<NSNumber *> *set = [NSMutableSet set];
    for (NSNumber *nvkat in self.nvkatArray) {
      [set addObject:nvkat];
    }
    for (NSNumber *materialNumber in set) {
      MSCMaterial *material = [[MSCMaterial alloc] initWithNumberOfMaterial: [materialNumber intValue]
                                                                      color: [self getColorForMaterialNumber:[materialNumber intValue]]];
      [self.mMaterials addObject:material];
    }
    self.materials = [self.mMaterials copy];
    self.selectedMaterials = [self.mMaterials copy];
    
    [self createElementArray];
    if (self.profileArray.count > 0) {
      [self createReceiverSurface];
    }
  }
}

- (void)createElementArray
{
  
}

- (void)createReceiverSurface
{
  
}

- (SCNVector3)getColorForMaterialNumber:(int)materialNumber
{
  switch (materialNumber)
  {
  case 0:
    return SCNVector3Make(0.5, 0, 0);
  case 1:
    return SCNVector3Make(1, 0, 0);
  case 2:
    return SCNVector3Make(0, 1, 0);
  case 3:
    return SCNVector3Make(0, 0, 1);
  case 4:
    return SCNVector3Make(1, 0, 1);
  case 5:
    return SCNVector3Make(1, 0.5, 0);
  case 6:
    return SCNVector3Make(0.2, 0.4, 1);
  case 7:
    return SCNVector3Make(0.8, 1, 0);
  case 8:
    return SCNVector3Make(0.4, 0, 1);
  case 9:
    return SCNVector3Make(0.4, 0.4, 0.4);
  case 10:
    return SCNVector3Make(1, 0.4, 0.5);
  case 11:
    return SCNVector3Make(0, 0.5, 0.5);
  case 12:
    return SCNVector3Make(0, 0.3, 0);
  case 13:
    return SCNVector3Make(0, 1, 0.5);
  case 14:
    return SCNVector3Make(1, 1, 0.5);
  case 15:
    return SCNVector3Make(1, 0.5, 0.5);
  default:
    return SCNVector3Make(0.6, 0.6, 0.6);
  }
}

@end
