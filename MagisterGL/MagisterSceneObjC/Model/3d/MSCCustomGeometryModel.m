#import "MSCCustomGeometryModel.h"

#import "MagisterGL-Swift.h"

#import "MSCFileManager.h"
#import "MSCColorGenerator.h"
#import "MSCMaterial.h"
#import "MSCHexahedron.h"

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
  self.neibArray = [self.fileManager getNEIBArrayWithPath:[documentsPath stringByAppendingString:project.elemNeibFilePath]];
  self.sig3dArray = [self.fileManager getSig3dArrayWithPath:[documentsPath stringByAppendingString:project.sigma3dPath]];
  self.profileArray = [self.fileManager getProfileArrayWithPath:[documentsPath stringByAppendingString:project.profilePath]];
  self.edsallArray = [self.fileManager getEdsallArrayWithPath:[documentsPath stringByAppendingString:project.edsallPath]];
  if (self.edsallArray.count > 0) {
    for (NSNumber *key in [self.edsallArray[0] allKeys]) {
      [self.mTimeSlices addObject:key];
    }
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    self.timeSlices = [[self.mTimeSlices sortedArrayUsingDescriptors:@[lowestToHighest]] copy];
    
//    self.timeSlices = [[self.mTimeSlices sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//      NSNumber *first = (NSNumber *)a;
//      NSNumber *second = (NSNumber *)b;
//      return [first compare:second];
//    }] copy];
  }
  NSArray<NSString *> *decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData: project.rnArrayPathsArray];
  for (NSString *rnArrayFilePath in decodedArray) {
    MSCRnData *rnTmpData = [self.fileManager getRnArrayWithPath:[documentsPath stringByAppendingString:rnArrayFilePath]];
    [self.mRnArray addObject:rnTmpData];
  }

  if (self.sig3dArray.count > 0) {
    NSMutableArray<NSArray<NSNumber *> *> *mSigma3dArray = [self.sig3dArray mutableCopy];
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [mSigma3dArray sortUsingDescriptors:@[lowestToHighest]];
//    mSigma3dArray = [[mSigma3dArray sortedArrayUsingComparator:^NSComparisonResult(id  a, id  b) {
//      NSArray<NSNumber *> *first = (NSArray<NSNumber *> *)a;
//      NSArray<NSNumber *> *second = (NSArray<NSNumber *> *)b;
//      return [first[1] compare:second[1]];
//    }] mutableCopy];
    
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
                                                                      color: [self getColorForMaterialWithNumber:[materialNumber intValue]]];
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
  self.elementsArray = [NSArray array];
  [self.mElementsArray removeAllObjects];
  
  self.minVector = SCNVector3Zero;
  self.maxVector = SCNVector3Zero;
  // минимумы и максимумы по осям
  NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
  
  NSMutableArray<NSNumber *> *xArray = [NSMutableArray array];
  for (NSValue *value in self.xyzArray) {
    SCNVector3 vector = [value SCNVector3Value];
    [xArray addObject:[NSNumber numberWithFloat:vector.x]];
  }
  [xArray sortUsingDescriptors:@[lowestToHighest]];
  
  NSMutableArray<NSNumber *> *yArray = [NSMutableArray array];
  for (NSValue *value in self.xyzArray) {
    SCNVector3 vector = [value SCNVector3Value];
    [yArray addObject:[NSNumber numberWithFloat:vector.y]];
  }
  [yArray sortUsingDescriptors:@[lowestToHighest]];
  
  NSMutableArray<NSNumber *> *zArray = [NSMutableArray array];
  for (NSValue *value in self.xyzArray) {
    SCNVector3 vector = [value SCNVector3Value];
    [zArray addObject:[NSNumber numberWithFloat:vector.z]];
  }
  [zArray sortUsingDescriptors:@[lowestToHighest]];
  
  self.minVector = SCNVector3Make([[xArray firstObject] floatValue],
                                  [[yArray firstObject] floatValue],
                                  [[zArray firstObject] floatValue]);
  self.maxVector = SCNVector3Make([[xArray lastObject] floatValue],
                                  [[yArray lastObject] floatValue],
                                  [[zArray lastObject] floatValue]);
  self.scaleValue = 1.0f / fabsf((self.maxVector.y - self.minVector.y) / 8.0f);
  self.centerPoint = SCNVector3Make((self.maxVector.x - self.minVector.x) / 2.0f + self.minVector.x,
                                    (self.maxVector.y - self.minVector.y) / 2.0f + self.minVector.y,
                                    (self.maxVector.z - self.minVector.z) / 2.0f + self.minVector.z);
  
  if (self.isDrawingSectionEnabled) {
//    MSCCrossSection *crossSection = [[MSCCrossSection alloc] initWithPlane: ]
  }

//
//  if isDrawingSectionEnabled
//  {
//    let crossSection: MAGCrossSection = MAGCrossSection(plane: sectionType,
//                                                        value: sectionValue,
//                                                        greater: self.greater)
//    self.crossSection = crossSection
//  }
//
  
  NSMutableArray<NSNumber *> *xyzValuesArray = [NSMutableArray array];
  if (self.showFieldNumber != -1) {
    xyzValuesArray = [self.fieldsArray[self.showFieldNumber] mutableCopy];
    [xyzValuesArray sortUsingDescriptors:@[lowestToHighest]];
    float min = [[xyzValuesArray firstObject] floatValue];
    float max = [[xyzValuesArray lastObject] floatValue];
    MSCColorGenerator *colorGenerator = [[MSCColorGenerator alloc] init];
    [colorGenerator generateColorWithMinValue:(double)min
                                     maxValue:(double)max];
    self.colorGenerator = colorGenerator;
  }
  
  int numberOfElement = 0;
  for (int i=0; i<self.nverArray.count; i++) {
    NSArray *positionArray = [self getNVERArrayForNumber:i];
    
//   HexahedronVisible isVisibleHexahedron = self.isDrawingSectionEnabled ? [self.crossSection setVisibleToHexahedronWithPositions: positionArray] : isVisible;
    
    //заглушка
    HexahedronVisible visible = isVisible;

    NSArray<NSArray<NSNumber *> *> *elementsNeibsArray = [self generateNeibsElementArrayWithNumber:i];
    
    MSCHexahedron *hexahedron;
    int material = [self.nvkatArray[numberOfElement] intValue];
    
    if (self.showFieldNumber != -1) {
      NSMutableArray *colors = [NSMutableArray array];
      int j = 0;
      for (NSNumber *number in self.nvkatArray[numberOfElement]) {
        if (j < 8) {
          [colors addObject:[NSValue valueWithSCNVector3:[self.colorGenerator getColorForU:(double)[xyzValuesArray[[number intValue] - 1] floatValue]]]];
        }
        else {
          break;
        }
        j++;
      }
      hexahedron = [[MSCHexahedron alloc] initWithPositions:positionArray
                                                 neighbours:elementsNeibsArray
                                                   material:material
                                                     colors:colors];
    }
    else if (self.sig3dArray.count == 0) {
      hexahedron = [[MSCHexahedron alloc] initWithPositions:positionArray
                                                 neighbours:elementsNeibsArray
                                                   material:material
                                                     colors:@[[NSValue valueWithSCNVector3:[self getColorForMaterialWithNumber:       [self.nvkatArray[numberOfElement] intValue]]]]];
    }
    else {
      float uValue = 0.0f;
      for (NSArray *materialSig3d in self.sig3dArray) {
        if (material == [materialSig3d[0] intValue]) {
          uValue = [materialSig3d[1] floatValue];
        }
      }
      hexahedron = [[MSCHexahedron alloc] initWithPositions:positionArray
                                                 neighbours:elementsNeibsArray
                                                   material:material
                                                     colors:@[[NSValue valueWithSCNVector3:[self.colorGenerator getColorForU: uValue]]]];
    }
    
    [hexahedron generateSides];
    hexahedron.visible = visible;
    if (visible == isVisible) {
      [self.mElementsArray addObject:hexahedron];
    }
    
    numberOfElement++;
  }
  self.elementsArray = [self.mElementsArray copy];
}

- (void)createReceiverSurface
{
  
}

- (NSArray *)getNVERArrayForNumber:(int)number
{
  NSMutableArray *positionArray = [NSMutableArray array];
  int i = 0;
  
  for (NSNumber *gridNum in self.nverArray[number]) {
    if (i < 8) {
      SCNVector3 vector = [self.xyzArray[[gridNum intValue] -1] SCNVector3Value];
      [positionArray addObject:[NSValue valueWithSCNVector3:vector]];
    }
    i++;
  }
  return [positionArray copy];
}

- (NSArray<NSArray<NSNumber *> *> *)generateNeibsElementArrayWithNumber:(int)number
{
  NSMutableArray<NSArray<NSNumber *> *> *elementNeibsArray = [NSMutableArray array];
  for (int numberOfSide = 0; numberOfSide < 6; numberOfSide++) {
    NSMutableArray<NSNumber *> *neibs = [self.neibArray[6 * number + numberOfSide] mutableCopy];
    NSMutableArray<NSNumber *> *resNeibs = [NSMutableArray array];
    if (neibs.count >=1 && [neibs[0] intValue] == 0) {
      [resNeibs addObject:[NSNumber numberWithInt:0]];
    }
    else {
      NSMutableArray<NSNumber *> *neibsNumbers = [NSMutableArray array];
      for (int i = 0; i < [neibs[0] intValue]; i++) {
        // если материал соседа выключен, мы должны это учесть
        /** строка двумерного массива ELEM NEIB содержит:
         [количество соседей, номера соседей(нумерация соседей с единицы)]
         
         elementsMaterialsArray содержит:
         [номера материалов соседей]
         номера материалов соседей берутся из NVKAT
         
         NVKAT одномерный массив:
         
         nvkat[index] - номер материала
         
         index - номер соседа начиная с нуля
         */
        int index = [self.nvkatArray[[neibs[i + 1] intValue] - 1] intValue];
        if (![self findInSelectedMaterialsWithNumber: index]) {
          break;
        }
        else {
          if (!self.isDrawingSectionEnabled) {
            [neibsNumbers addObject:neibs[i + 1]];
          }
          else {
            if ([self isElementsVisibleWithNumber:[neibs[i + 1] intValue] -1]) {
              [neibsNumbers addObject:neibs[i + 1]];
            }
            else  {
              [neibsNumbers removeAllObjects];
            }
          }
        }
      }
      [resNeibs addObject:[NSNumber numberWithInt:(int)neibsNumbers.count]];
      [resNeibs addObjectsFromArray:[neibsNumbers copy]];
    }
    [elementNeibsArray addObject:[resNeibs copy]];
  }
  return [elementNeibsArray copy];
}

- (BOOL)findInSelectedMaterialsWithNumber:(int)numberOfMaterial
{
  for (MSCMaterial *selectedMaterial in self.selectedMaterials) {
    if (numberOfMaterial == selectedMaterial.numberOfMaterial) {
      return YES;
    }
  }
  return NO;
}

- (BOOL)isElementsVisibleWithNumber:(int)numberOfElement
{
  NSArray *positionArray = [self getNVERArrayForNumber:numberOfElement];
  if (positionArray.count > 0) {
    if (self.crossSection != nil) {
//      return [self.crossSection setVisibleToHexahedronWithPositions: positionArray];
      return NO;
    }
    else {
      return YES;
    }
  }
  return NO;
}

- (SCNVector3)getColorForMaterialWithNumber:(int)materialNumber
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
