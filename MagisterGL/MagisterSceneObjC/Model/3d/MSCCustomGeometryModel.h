#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class MSCFileManager;
@class MSCColorGenerator;
@class MSCProject;
@class MSCHexahedron;

@interface MSCCustomGeometryModel : NSObject

@property (nonatomic, strong) MSCFileManager *fileManager; // need value in init
@property (nonatomic, strong) MSCColorGenerator *colorGenerator;
@property (nonatomic, strong) MSCProject *project;
@property (nonatomic) BOOL isShowMaterial; // need value in init
@property (nonatomic) int showFieldNumber; // need value in init
@property (nonatomic) int showTimeSliceNumber; // need value in init
@property (nonatomic) int showTimeSliceForCharts; // need value in init
@property (nonatomic) float scaleValue; // need value in init
@property (nonatomic) BOOL isDrawingSectionEnabled; // need value in init
@property (nonatomic) MSCHexahedron *elementsArray; // need value in init
@property (nonatomic) SCNVector3 centerPoint;
@property (nonatomic) SCNVector3 minVector;
@property (nonatomic) SCNVector3 maxVector;
@property (nonatomic, strong) NSArray *xyzArray;
@property (nonatomic, strong) NSArray<NSArray *> *fieldsArray;
@property (nonatomic, strong) NSArray<NSArray *> *nverArray;
@property (nonatomic, strong) NSArray *nvkatArray;
@property (nonatomic, strong) NSArray<NSArray *> *neibArray;








//var sectionType: PlaneType = .X
//var sectionValue: Float = 0
//var greater: Bool = true
//var materials: [MAGMaterial] = []
//var selectedMaterials: [MAGMaterial] = []
//var crossSection: MAGCrossSection?
//var sig3dArray: [[Double]] = []
//var profileArray: [SCNVector3] = []
//var chartsData: MAGChartsData = MAGChartsData()
//var edsallArray: [[Float: Float]] = []
//var rnArray: [MAGRnData] = []
//
//var timeSlices: [Float] = []
//var receiversSurface: [MAGTriangleElement] = []
//
//var timeSlicesForCharts: [Int] = []


@end
