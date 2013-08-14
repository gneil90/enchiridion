//
//  Animations.m
//  templateARC
//
//  Created by Mac Owner on 3/8/13.
//
//

#import "Animations.h"

@implementation Animations
-(id)init
{
    self=[super init];
    if (self)
    {
        self.nameImage=nil;
        self.animationType=kAnimationDefault;
    }
    return self;
}
@end
