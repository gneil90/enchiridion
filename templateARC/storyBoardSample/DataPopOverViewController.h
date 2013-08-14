//
//  DataPopOverViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/13/13.
//
//

#import <UIKit/UIKit.h>

@protocol DataPopoverViewDelegate <NSObject>

-(void)didPickCellAndStartSegue:(NSString*)segueIdentifier;

@end

@interface DataPopOverViewController : UITableViewController

@property (weak,nonatomic) id delegate;

@end
