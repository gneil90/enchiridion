//
//  healthButton.m
//  templateARC
//
//  Created by Mac Owner on 3/4/13.
//
//

#import "HealthButton.h"
#import "Fugitive.h"
#import "UIView+AnchorPoint.h"

@implementation HealthButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self setBackgroundImage:[UIImage imageNamed:@"h.png"] forState:UIControlStateNormal];
        self.transform=CGAffineTransformScale(self.transform, 0.8, 0.8);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.glitterType=kGlitterHealth;
        self.subbuttonType=kHealthSubButtonType;
        self.stringType=@"Health";
    }
    return self;
}

-(void)setupBackgroundImage
{
    NSArray *arrayOfSubobjectives=[self.toDoAssignment.subObjective allObjects];
    
    if ([arrayOfSubobjectives count]>0) {
        [self setBackgroundImage:[UIImage imageNamed:@"h1_subobjective.png"] forState:UIControlStateNormal];
        //self.transform=CGAffineTransformScale(self.transform, 1.3f, 1.3f);
        //[self.imageView setNewUserAnchorPoint:CGPointMake(-0.9f, 0.9f)];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"h.png"] forState:UIControlStateNormal];
    }
    [self sizeToFit];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
