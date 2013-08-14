//
//  CircleView.h
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "CoordinatesController.h"

@interface CircleView : UIView

@property (assign,nonatomic) BOOL labelEnable;
@property (assign,nonatomic) BOOL needToCreateArray;
@property (assign,nonatomic) BOOL needToCreateArrayForSubobjectives;

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) NSNumber *numberForlabel;

@property (assign,nonatomic) BOOL isVisible;
@property (assign,nonatomic) CGFloat brush;
@property (assign,nonatomic) CGFloat alphaParam;

@property (strong,nonatomic) NSDate *date;

//@property (strong,nonatomic) CoordinatesController *coordinateToDrawButton;
@property (strong,nonatomic) NSMutableArray *arrayFinanceCoordinatesToDrawButton;
@property (strong,nonatomic) NSMutableArray *arrayHealthCoordinatesToDrawButton;
@property (strong,nonatomic) NSMutableArray *arrayPrivateLifeCoordinatesToDrawButton;
@property (strong,nonatomic) NSMutableArray *arraySubobjectivesCoordinatesToDrawButton;


@property (assign,nonatomic) int tag;

@property (assign, nonatomic) CGPoint buttonDraw1;

@property (assign, nonatomic) CGPoint RadiusOfCircle;

@property (assign,nonatomic) CGFloat colorWithRed;
@property (assign,nonatomic) CGFloat colorWithGreen;
@property (assign,nonatomic) CGFloat colorWithBlue;



-(NSMutableArray*)createArrayOfPointsWithDeltaStep:(int)step fromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle withDeltaBetweenButtons:(u_int)dlinaDugiConstraint assignTypeOfButton:(ButtonTypes)buttonType;
-(void)createArraysWithCoordinatesForAllButtonTypes;


@end
