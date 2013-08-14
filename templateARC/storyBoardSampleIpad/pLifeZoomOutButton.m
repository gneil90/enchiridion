//
//  pLifeZoomOutButton.m
//  templateARC
//
//  Created by Mac Owner on 5/7/13.
//
//

#import "pLifeZoomOutButton.h"
#import "CoordinatesController.h"
#import "Fugitive.h"


@implementation pLifeZoomOutButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.subbuttonType = kPrivateLifeZoomOutSubButtonType;
        self.transform=CGAffineTransformScale(self.transform, 0.8, 0.8);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"p1_secondView.png"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.stringType=@"Private Life Zoom Out";
        
    }
    return self;
}

-(void)setupBackgroundImage
{
    NSArray *arrayOfSubobjectives=[self.toDoAssignment.subObjective allObjects];
    
    if ([arrayOfSubobjectives count]>0) {
        [self setBackgroundImage:[UIImage imageNamed:@"p1_subobjective.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"p1_secondView.png"] forState:UIControlStateNormal];
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
