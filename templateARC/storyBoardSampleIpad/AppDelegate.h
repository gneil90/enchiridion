//
//  AppDelegate.h
//  storyBoardSampleIpad
//
//  Created by Mac Owner on 2/9/13.
//
//

#import <UIKit/UIKit.h>
@class CombinedViewController;
@class MapDetailsViewController;
@class MainMapViewController;
@class MenuViewController;
@class MainMapZoomOutViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) CombinedViewController *combinedViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
