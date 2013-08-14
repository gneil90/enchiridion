//
//  HealthZoomOutButton.m
//  templateARC
//
//  Created by Mac Owner on 3/16/13.
//
//

#import "HealthZoomOutButton.h"
#import "CoordinatesController.h"
#import "Fugitive.h"


@implementation HealthZoomOutButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.subbuttonType = kHealthZoomOutSubButtonType;
        self.transform=CGAffineTransformScale(self.transform, 0.8, 0.8);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.stringType=@"Health Zoom Out";
    }
    return self;
}


-(void)setupBackgroundImage
{
    NSArray *arrayOfSubobjectives=[self.toDoAssignment.subObjective allObjects];
    
    if ([arrayOfSubobjectives count]>0) {
        [self setBackgroundImage:[UIImage imageNamed:@"h1_subobjective.png"] forState:UIControlStateNormal];
        self.transform=CGAffineTransformScale(self.transform, 0.8f, 0.8f);

    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"h1_secondView.png"] forState:UIControlStateNormal];
    }
    
    
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
