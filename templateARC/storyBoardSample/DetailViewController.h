//
//  DetailViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/13/13.
//
//

#import <UIKit/UIKit.h>
#import "DataPopOverViewController.h"
@interface DetailViewController : UIViewController
<UISplitViewControllerDelegate,UIPopoverControllerDelegate,DataPopoverViewDelegate>
@property (nonatomic, retain) IBOutlet UIBarButtonItem *menuButton;
@property (nonatomic,strong) UIPopoverController *masterPopoverController;

@end
