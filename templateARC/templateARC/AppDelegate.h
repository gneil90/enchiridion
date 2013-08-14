//
//  AppDelegate.h
//  templateARC
//
//  Created by Mac Owner on 2/6/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    CCDirectorIOS	*__unsafe_unretained director_;	// weak ref

}
@property (unsafe_unretained, readonly) CCDirectorIOS *director;


@property (nonatomic, retain) UIWindow *window;

@end
