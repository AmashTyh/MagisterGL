#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class MAGProject;
@class MSCFileManager;
@class MSCRnData;
@class MSCColorGenerator;

@class MSCMaterial;
@class MSCCrossSection;
@class MSCHexahedron;
@class MSCChartsData;
@class MSCTriangleElement;

@interface MSCCustomGeometryModel : NSObject

@property (nonatomic, strong) MSCFileManager *fileManager;
@property (nonatomic, strong) MSCColorGenerator *colorGenerator;
@property (nonatomic, strong) MAGProject *project;  
@property (nonatomic) BOOL isShowMaterial;
@property (nonatomic) int showFieldNumber;
@property (nonatomic) int showTimeSliceNumber;
@property (nonatomic) int showTimeSliceForCharts;
@property (nonatomic) float scaleValue;
@property (nonatomic) BOOL isDrawingSectionEnabled;
@property (nonatomic, strong) NSArray<MSCHexahedron *> *elementsArray; // arrayWork
@property (nonatomic) SCNVector3 centerPoint;
@property (nonatomic) SCNVector3 minVector;
@property (nonatomic) SCNVector3 maxVector;
@property (nonatomic, strong) NSArray *xyzArray;
@property (nonatomic, strong) NSArray<NSArray *> *fieldsArray;
@property (nonatomic, strong) NSArray<NSArray *> *nverArray;
@property (nonatomic, strong) NSArray *nvkatArray;
@property (nonatomic, strong) NSArray<NSArray *> *neibArray;
//@property (nonatomic) PlaneType sectionType; // need value in init
@property (nonatomic) float sectionValue;
@property (nonatomic) BOOL greater;
@property (nonatomic, strong) NSArray<MSCMaterial *> *materials;
@property (nonatomic, strong) NSArray<MSCMaterial *> *selectedMaterials;
@property (nonatomic, strong) MSCCrossSection *crossSection;
@property (nonatomic, strong) NSArray<NSArray *> *sig3dArray;
@property (nonatomic, strong) NSArray *profileArray;
@property (nonatomic, strong) MSCChartsData *chartsData; // need value in init
@property (nonatomic, strong) NSArray<NSDictionary *> *edsallArray;
@property (nonatomic, strong) NSArray<MSCRnData *> *rnArray;
@property (nonatomic, strong) NSArray *timeSlices;
@property (nonatomic, strong) NSArray<MSCTriangleElement *> *receiversSurface;
@property (nonatomic, strong) NSArray *timeSlicesForCharts;
//var sectionType: PlaneType = .X

- (void)configureWithProject:(MAGProject *)project;
- (void)createElementArray;
- (void)createReceiverSurface;

@end
