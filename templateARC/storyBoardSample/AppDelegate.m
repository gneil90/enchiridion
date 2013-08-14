//
//  AppDelegate.m
//  storyBoardSample
//
//  Created by Mac Owner on 2/8/13.
//
//

#import "AppDelegate.h"
#import "Player.h"
#import "PlayersViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.changeFlag=0;
    self.players = [NSMutableArray arrayWithCapacity:20];
	Player *player = [[Player alloc] init];
	player.name = @"Bill Evans";
	player.game = @"Tic-Tac-Toe";
	player.rating = 4;
	[self.players addObject:player];
	player = [[Player alloc] init];
	player.name = @"Oscar Peterson";
	player.game = @"Spin the Bottle";
	player.rating = 5;
	[self.players addObject:player];
	player = [[Player alloc] init];
	player.name = @"Dave Brubeck";
	player.game = @"Texas Hold’em Poker";
	player.rating = 2;
    [self.players addObject:player];
    NSLog(@"Players in array:%d",[self.players count]);
    UITabBarController *tabBarController;

    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
	tabBarController =
    (UITabBarController *)self.window.rootViewController;
    }
    else
    {
        UISplitViewController *splitViewController =
        (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
		tabBarController = [storyboard instantiateInitialViewController];
        
		NSArray *viewControllers = @[tabBarController, navigationController];
		splitViewController.viewControllers = viewControllers;

        splitViewController.delegate = (id)navigationController.topViewController;
    }
    self.navigationController =
    [[tabBarController viewControllers] objectAtIndex:0];
    
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.navigationController.navigationBarHidden=NO;
    
	PlayersViewController *playersViewController =
    [[self.navigationController viewControllers] objectAtIndex:0];
	playersViewController.players = self.players;
    return YES;
}
    


-(void)reloadDataTable:(UITableViewController*)controller;
{
    if (self.changeFlag==1)
    {
        [controller.tableView reloadData];
        self.changeFlag=0;
    }
}

-(void)addNewPlayer:(Player*)player
{
    [self.players addObject:player];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
