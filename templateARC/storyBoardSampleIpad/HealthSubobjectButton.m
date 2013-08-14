//
//  HealthSubobjectButton.m
//  templateARC
//
//  Created by Mac Owner on 5/27/13.
//
//

#import "HealthSubobjectButton.h"

@implementation HealthSubobjectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.subbuttonType=kHealthSubobjectButton;
        UIImage *image = [UIImage imageNamed:@"hsg.png"];
        self.isReachedImage = image;
        
        UIImage *image2 = [UIImage imageNamed:@"hsg0.png"];
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
