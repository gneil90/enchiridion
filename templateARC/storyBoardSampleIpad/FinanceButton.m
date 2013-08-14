//
//  FInanceButton.m
//  templateARC
//
//  Created by Mac Owner on 3/4/13.
//
//

#import "FinanceButton.h"

@implementation FinanceButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"f.png"] forState:UIControlStateNormal];
        self.transform=CGAffineTransformScale(self.transform, 0.8, 0.8);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.glitterType=kGlitterFinance;
        self.subbuttonType=kFinanceSubButtonType;
        self.stringType=@"Finance";
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
