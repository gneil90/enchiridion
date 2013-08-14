//
//  ButtonObjectClass.m
//  templateARC
//
//  Created by Mac Owner on 3/4/13.
//
//

#import "ButtonObjectClass.h"

@implementation ButtonObjectClass

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.glitterType=kGlitterNoneType;
        self.isDragging=NO;
        self.isIntersectingWithParentButton=NO;
        self.subobjective=nil;
        self.buttonState = kButtonStateDefault;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSString*)createRetinaNameIfNeeded:(NSString*)name
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        // Retina display
        name=[NSString stringWithFormat:@"%@_retina.png",name];
    }
    else
    {
        name=[NSString stringWithFormat:@"%@.png",name];
    }
    return name;
    
}


@end
