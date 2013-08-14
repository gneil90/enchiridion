//
//  BalanceBackgroundLayer.m
//  templateARC
//
//  Created by Mac Owner on 2/6/13.
//
//

#import "BalanceBackgroundLayer.h"

@implementation BalanceBackgroundLayer

-(id)init {
    self = [super init];                                           // 1
    if (self != nil) {                                             // 2
        CCSprite *backgroundImage;
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // 3
            // Indicates game is running on iPad
            backgroundImage = [CCSprite spriteWithFile:@"backGroundEnch.jpg"];
        } else {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
        }
        
        CGSize boundingBox = CGSizeMake([self boundingBox].size.width, [self boundingBox].size.height); // 4
        [backgroundImage setPosition:
         CGPointMake(boundingBox.width/2, boundingBox.height/2)]; // 5
        
        [self addChild:backgroundImage z:0 tag:0];
        // [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"HellMusic.caf"];
    }
    return self;
    
}


@end
