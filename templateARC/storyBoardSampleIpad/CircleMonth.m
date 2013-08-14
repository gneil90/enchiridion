//
//  CircleMonth.m
//  templateARC
//
//  Created by Mac Owner on 4/25/13.
//
//

#import "CircleMonth.h"
#import "CoordinatesController.h"

#define PI 3.140123
@interface CircleMonth()

-(CGPoint)coordinateOnCircle:(CGFloat)degreeValue;

@end


@implementation CircleMonth

-(id)init
    {
        self=[super init];
        if (self)
        {
           
        }
        return self;
    }


-(CGPoint)coordinateOnCircle:(CGFloat)degreeValue
{
    return CGPointMake(self.radius.x*cos(degreeValue*PI/180)+self.centerOfCircle.x, self.radius.y*sin(degreeValue*PI/180)+self.centerOfCircle.y);
}

-(void)createArrayOfCoordinatesForDrawZoomOutButtonsWithRadius:(CGPoint)radius withStep:(int)step centerOfCircle:(CGPoint)centerOfCircle
{
    self.radius=radius;
    self.centerOfCircle=centerOfCircle;
    
    int randomAngleFluctuation=0;
    
    NSMutableArray *arrayOfFinanceCoordinates=[NSMutableArray new];
    int i=60+randomAngleFluctuation;
    int jFix=60+randomAngleFluctuation;
    int delta=i-jFix;
    while (i<160+randomAngleFluctuation) {
        if ((delta==0)&&(jFix==60+randomAngleFluctuation)) {
            
            CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
            coordinateToDrawButton.pointIsEmpty=YES;
            coordinateToDrawButton.degreeValue=i;
            coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
            coordinateToDrawButton.typeOfButton=kFinanceTypeButton;
            [arrayOfFinanceCoordinates addObject:coordinateToDrawButton];
            i+=step;
            delta=i-jFix;
        }
        else if (delta>=0)
        {
            CGFloat dlinaDugi=self.radius.x*delta*PI/180;
            if (dlinaDugi>50)
            {
                CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
                coordinateToDrawButton.pointIsEmpty=YES;
                coordinateToDrawButton.degreeValue=i;
                coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
                coordinateToDrawButton.typeOfButton=kFinanceTypeButton;
                [arrayOfFinanceCoordinates addObject:coordinateToDrawButton];
                jFix=i;
            }
            delta=i-jFix;
            i+=step;
        }
    }
    self.arrayFinanceCoordinatesToDrawButton=arrayOfFinanceCoordinates;

    
    NSMutableArray *arrayOfHealthCoordinates=[NSMutableArray new];
    i=180+randomAngleFluctuation;
    jFix=180+randomAngleFluctuation;
    delta=i-jFix;
    while (i<280+randomAngleFluctuation) {
        if ((delta==0)&&(jFix==180+randomAngleFluctuation)) {
            
            CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
            coordinateToDrawButton.pointIsEmpty=YES;
            coordinateToDrawButton.degreeValue=i;
            coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
            coordinateToDrawButton.typeOfButton=kHealthTypeButton;
            [arrayOfHealthCoordinates addObject:coordinateToDrawButton];
            i+=step+arc4random()%1;
            delta=i-jFix;
        }
        else if (delta>=0)
        {
            CGFloat dlinaDugi=self.radius.x*delta*PI/180;
            if (dlinaDugi>50)
            {
                CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
                coordinateToDrawButton.pointIsEmpty=YES;
                coordinateToDrawButton.degreeValue=i;
                coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
                coordinateToDrawButton.typeOfButton=kHealthTypeButton;
                [arrayOfHealthCoordinates addObject:coordinateToDrawButton];
                jFix=i;
            }
            delta=i-jFix;
            i+=step;
        }
    }
    self.arrayHealthCoordinatesToDrawButton=arrayOfHealthCoordinates;
    
    NSMutableArray *arrayOfPrivateLifeCoordinates=[NSMutableArray new];
    i=312+randomAngleFluctuation;
    jFix=312+randomAngleFluctuation;
    delta=i-jFix;
    while (i<408) {
        if ((delta==0)&&(jFix==312+randomAngleFluctuation)) {
            
            CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
            coordinateToDrawButton.pointIsEmpty=YES;
            coordinateToDrawButton.degreeValue=i;
            coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
            coordinateToDrawButton.typeOfButton=kPrivateLifeButton;
            [arrayOfPrivateLifeCoordinates addObject:coordinateToDrawButton];
            i+=step;
            delta=i-jFix;
        }
        else if (delta>=0)
        {
            CGFloat dlinaDugi=self.radius.x*delta*PI/180;
            if (dlinaDugi>50)
            {
                CoordinatesController *coordinateToDrawButton=[[CoordinatesController alloc]init];
                coordinateToDrawButton.pointIsEmpty=YES;
                coordinateToDrawButton.degreeValue=i;
                coordinateToDrawButton.pointToDrawButton=[self coordinateOnCircle:i];
                coordinateToDrawButton.typeOfButton=kPrivateLifeButton;
                [arrayOfPrivateLifeCoordinates addObject:coordinateToDrawButton];
                jFix=i;
            }
            delta=i-jFix;
            i+=step;
        }
    }
    self.arrayPrivateLifeCoordinatesToDrawButton=arrayOfPrivateLifeCoordinates;
    

}
@end
