//
//  GamePickerTableViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/9/13.
//
//

#import <UIKit/UIKit.h>
@class GamePickerViewController;
@protocol GamePickerViewControllerDelegate
- (void)gamePickerViewController:
(GamePickerViewController *)controller
                   didSelectGame:(NSString *)game;
@end

@interface GamePickerTableViewController : UITableViewController
{
     NSArray * games;
}
@property (weak,nonatomic) id delegate;
@property (retain,nonatomic) NSString *game;
@end
