//
//  CoordinatesController.m
//  templateARC
//
//  Created by Mac Owner on 2/19/13.
//
//

#import "CoordinatesController.h"

@implementation CoordinatesController
-(id)init
{
    self=[super init];
    if (self)
    {
        //do additional setup here
        self.pointIsEmpty=YES;
        self.pointToDrawButton=CGPointZero;
    }
    return self;
}

@end
