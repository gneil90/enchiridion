//
//  AppDelegate.h
//  storyBoardSample
//
//  Created by Mac Owner on 2/8/13.
//
//

#import <UIKit/UIKit.h>
@class Player;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong,nonatomic) Player *playerChangeGestureRanking;
@property (assign,nonatomic) int changeFlag;

-(void)addNewPlayer:(Player*)player;

-(void)reloadDataTable:(UITableViewController*)controller;
@end
