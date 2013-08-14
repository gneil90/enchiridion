//
//  pLifeSubobjectButton.m
//  templateARC
//
//  Created by Mac Owner on 5/27/13.
//
//

#import "pLifeSubobjectButton.h"

@implementation pLifeSubobjectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.subbuttonType=kPrivateLifeSubobjectButton;
        [self setBackgroundImage:[UIImage imageNamed:@"psg0.png"] forState:UIControlStateNormal];
        [self sizeToFit];

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

@end
