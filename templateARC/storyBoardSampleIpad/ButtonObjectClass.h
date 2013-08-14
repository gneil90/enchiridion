//
//  ButtonObjectClass.h
//  templateARC
//
//  Created by Mac Owner on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import "macros.h"
@class Fugitive;
@class Subobjective;


@interface ButtonObjectClass : UIButton

@property (assign,nonatomic) GlitterType glitterType;
@property (assign,nonatomic) subButtonTypes subbuttonType;
@property (strong,nonatomic) NSDate *date;
@property (assign,nonatomic) CGPoint homePoint;
@property (assign,nonatomic) BOOL isDragging;

@property (assign,nonatomic) BOOL isIntersectingWithParentButton;
@property (strong,nonatomic) Fugitive *toDoAssignment;

@property (assign,nonatomic) int degreeRotationValue;
@property (nonatomic,strong) NSString *stringType;

@property (strong,nonatomic) Subobjective *subobjective;


@property (strong,nonatomic) UIImage * imageWithSubobjective;
@property (strong,nonatomic) UIImage *imageWithNoSubobjective;
@property (assign,nonatomic) ButtonStates buttonState;




-(NSString*)createRetinaNameIfNeeded:(NSString*)name;
-(void)setupBackgroundImage;

@end
