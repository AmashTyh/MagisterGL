#import <Foundation/Foundation.h>


@class MAGSide;

typedef NS_ENUM(NSUInteger, HexahedronVisible) {
  isVisible,
  notVisible,
};

@interface MSCHexahedron : NSObject

@property(nonatomic, strong) NSArray *positions;
/**
 Массив сторон шестигранника - 6 штук
 порядок: левая, передняя, нижняя, правая, задняя, верхняя
 */
@property(nonatomic, strong) NSArray<MAGSide *> *sidesArray;
@property(nonatomic, strong) NSArray *isSideVisibleArray;
/**
 Массив nvkat для элемента
 */
@property(nonatomic, strong) NSArray<NSArray<NSNumber *> *> *neighbours;
/**
 Материал - целое число
 */
@property(nonatomic) int material;
@property(nonatomic) HexahedronVisible visible;
@property(nonatomic, strong) NSArray *colors;

- (instancetype)initWithPositions:(NSArray *)positions
                       neighbours:(NSArray<NSArray<NSNumber *> *> *)neighbours
                         material:(int)material
                           colors:(NSArray *)colors;
- (void)generateSides;
- (void)setColorToSides;

@end
