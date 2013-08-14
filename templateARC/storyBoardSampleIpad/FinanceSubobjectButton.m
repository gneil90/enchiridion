//
//  FinanceSubobjectButton.m
//  templateARC
//
//  Created by Mac Owner on 5/27/13.
//
//

#import "FinanceSubobjectButton.h"

@implementation FinanceSubobjectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.subbuttonType=kFinanceSubobjectButton;
        UIImage *image = [UIImage imageNamed:@"fsg.png"];
        self.isReachedImage = image;
        
        UIImage *image2 = [UIImage imageNamed:@"fsg0.png"];
        self.isNotReachedImage = image2;
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
