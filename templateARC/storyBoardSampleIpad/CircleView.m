//
//  CircleView.m
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//
#import <math.h>
#import "CircleView.h"
#import "macros.h"
#import "UIImage+ImmediateLoading.h"

#define PI 3.14159265
@interface CircleView ()
- (void)drawRect:(CGRect)rect;
-(CGPoint)coordinateOnCircle:(CGFloat)degreeValue;
@end

@implementation CircleView
{
    CGPoint centerOfCircle;
    CGRect frameOfCircle2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.labelEnable=NO;
        self.isVisible=YES;
        self.needToCreateArrayForSubobjectives=NO;
        self.date=nil;
        self.colorWithRed = 23.0f/255.0f;
        self.colorWithGreen = 12.0f/255.0f;
        self.colorWithBlue = 0.0f;
        
    }
    return self;
}

#pragma mark-Определение координаты на окружности
-(CGPoint)coordinateOnCircle:(CGFloat)degreeValue
{
    if (self.RadiusOfCircle.x==0) {
         frameOfCircle2=CGRectMake(self.brush/2,self.brush/2, self.frame.size.width-self.brush-1.0f, self.frame.size.height-self.brush);
        
         centerOfCircle=CGPointMake(self.brush/2+frameOfCircle2.size.width/2,self.brush/2+ frameOfCircle2.size.height/2);
        
        self.RadiusOfCircle=CGPointMake(centerOfCircle.x-self.brush/2, centerOfCircle.y-self.brush/2);
    }
   
    
    return CGPointMake(self.RadiusOfCircle.x*cos(degreeValue*PI/180)+centerOfCircle.x, self.RadiusOfCircle.y*sin(degreeValue*PI/180)+centerOfCircle.y);
}

-(NSMutableArray*)createArrayOfPointsWithDeltaStep:(int)step fromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle withDeltaBetweenButtons:(u_int)dlinaDugiConstraint assignTypeOfButton:(ButtonTypes)buttonType
{
    int randomAngleFluctuation=0;
    
    NSMutableArray *arrayOfCoordinates=[NSMutableArray new];
    
    //угол для начала отсчета переборки
    int i=fromAngle+randomAngleFluctuation;
    //угол для измерения дельты после создания точки для кнопки
    int jFix=fromAngle+randomAngleFluctuation;
    //разница величин углов для измерения длины дуги 
    int delta=i-jFix;
    //переборка углов с шагом 2 градуса
    while (i<toAngle+randomAngleFluctuation) {
        //условия начального отсчета
        if ((delta==0)&&(jFix==fromAngle+randomAngleFluctuation)) {
            
            CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
            coordinateToDrawButton.pointIsEmpty=YES;
            coordinateToDrawButton.isPointConverted=NO;
            coordinateToDrawButton.degreeValue=i;
            coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
            coordinateToDrawButton.typeOfButton=buttonType;
            [arrayOfCoordinates addObject:coordinateToDrawButton];
            i+=step;
            delta=i-jFix;
        }
        else if (delta>=0)
        {
            CGFloat dlinaDugi=self.RadiusOfCircle.x*delta*PI/180.0f;
            if (dlinaDugi>dlinaDugiConstraint)
            {
            CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
            coordinateToDrawButton.pointIsEmpty=YES;
            coordinateToDrawButton.isPointConverted=NO;
            coordinateToDrawButton.degreeValue=i;
            coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
            coordinateToDrawButton.typeOfButton=buttonType;
            [arrayOfCoordinates addObject:coordinateToDrawButton];
            jFix=i;
            }
            delta=i-jFix;
            i+=step;
        }
    }
    return arrayOfCoordinates;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString *string = [NSString stringWithFormat:@"circle%d",self.tag];
    UIImage *image = [UIImage imageWithIdentifier:string forSize:CGSizeMake(self.frame.size.width, self.frame.size.height) andDrawingBlock:^{
    
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        CGRect frameOfCircle=CGRectMake(self.brush/2,self.brush/2, self.frame.size.width-self.brush-1.0f, self.frame.size.height-self.brush);
        // Draw a circle (border only)
        CGContextSetLineWidth(contextRef, self.brush);
        UIColor *color = [UIColor colorWithRed:self.colorWithRed green:self.colorWithGreen blue:self.colorWithBlue alpha:self.alphaParam];
        [color set];
        CGContextStrokeEllipseInRect(contextRef, frameOfCircle);
    
    }];
    [image drawAtPoint:CGPointZero];
        if (self.labelEnable)
    {
        CGRect frame=CGRectMake(0, 0, 20, 20);
        self.label=[[UILabel alloc]initWithFrame:frame];
        self.label.center=[[self.arrayHealthCoordinatesToDrawButton objectAtIndex:0] pointToDrawButton];
        self.label.textAlignment=NSTextAlignmentCenter;
        self.label.textColor=[UIColor whiteColor];
        self.label.backgroundColor=[UIColor clearColor];
        self.label.text=[self.numberForlabel stringValue];
        [self addSubview:self.label];
    }
    
    

}
-(void)createArraysWithCoordinatesForAllButtonTypes
{
    if (self.needToCreateArray)
                {
        
                       if (!self.arrayFinanceCoordinatesToDrawButton) {
                    self.arrayFinanceCoordinatesToDrawButton=[self createArrayOfPointsWithDeltaStep:2 fromAngle:60.0f toAngle:160.0f withDeltaBetweenButtons:100 assignTypeOfButton:kFinanceTypeButton];
                }
                
                self.arrayHealthCoordinatesToDrawButton=[self createArrayOfPointsWithDeltaStep:2 fromAngle:180.0f toAngle:280.0f withDeltaBetweenButtons:100 assignTypeOfButton:kHealthTypeButton];
                self.arrayPrivateLifeCoordinatesToDrawButton=[self createArrayOfPointsWithDeltaStep:2 fromAngle:312.0f toAngle:408.0f withDeltaBetweenButtons:100 assignTypeOfButton:kPrivateLifeButton];
 
}
}

@end
