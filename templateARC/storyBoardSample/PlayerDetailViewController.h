//
//  PlayerDetailViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/8/13.
//
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "GamePickerTableViewController.h"
@class PlayerDetailViewController;
@protocol PlayerDetailsViewControllerDelegate
- (void)playerDetailsViewControllerDidCancel:(PlayerDetailViewController *)controller;
- (void)playerDetailsViewController:
(PlayerDetailViewController *)controller
                       didAddPlayer:(Player *)player;
- (void)playerDetailsViewController:
(PlayerDetailViewController *)controller
                      didEditPlayer:(Player *)player;
@end

@interface PlayerDetailViewController : UITableViewController
<UITextFieldDelegate,GamePickerViewControllerDelegate>

@property (weak,nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextField *addName;
@property (nonatomic, weak) id <PlayerDetailsViewControllerDelegate> delegate;
@property (retain,nonatomic) NSString *gameName;
@property (strong, nonatomic) Player *playerToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end

