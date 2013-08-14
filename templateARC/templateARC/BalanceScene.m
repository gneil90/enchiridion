//
//  HelloWorldLayer.m
//  templateARC
//
//  Created by Mac Owner on 2/6/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "BalanceScene.h"
#import "BalanceBackgroundLayer.h"
// HelloWorldLayer implementation
@implementation BalanceScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *balanceScene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BalanceScene *layer = [BalanceScene node];
    BalanceBackgroundLayer *background = [BalanceBackgroundLayer node];
	
	// add layer as a child to scene
	[balanceScene addChild: layer z:5];
	[balanceScene addChild:background z:0];
	// return the scene
	return balanceScene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	
	
	return self;
}


@end
