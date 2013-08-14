//
//  DetailViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/13/13.
//
//

#import "DetailViewController.h"
#import "DataPopOverViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
@implementation DetailViewController
{
    UIPopoverController *_menuPopoverController;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:
(UISplitViewController *)splitViewController
willHideViewController:(UIViewController *)viewController
withBarButtonItem:(UIBarButtonItem *)barButtonItem
forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Players";
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    [self.masterPopoverController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //NSMutableArray *items = [[self.navigationController.toolbar items] mutableCopy];
    //[items insertObject:barButtonItem atIndex:0];
    //[self setToolbarItems:items animated:YES];
    //self.navigationItem.leftBarButtonItem=barButtonItem;
    self.masterPopoverController = popoverController;
   
}

- (void)splitViewController:
(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //NSMutableArray *items = [[self.navigationController.toolbar items] mutableCopy];
    //[items removeObject:barButtonItem];
    //[self setToolbarItems:items animated:YES];
    //self.navigationItem.leftBarButtonItem=nil;
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPopover"])
    {
        if (_menuPopoverController != nil &&
            _menuPopoverController.popoverVisible)
        {
            [_menuPopoverController dismissPopoverAnimated:NO];
        }
        
        //получаем сигвей (UIStoryBoardSegue), будем указывать на субкласс popOverSegue
        _menuPopoverController =  ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuPopoverController.delegate = self;
        
        //указатель на контроллер содержимого popOver (т.к. contentViewController возвращает UIViewController
        DataPopOverViewController *tableViewController = (DataPopOverViewController *)_menuPopoverController.contentViewController;
        tableViewController.delegate=self;
    }
    else if ([segue.identifier isEqualToString:@"ViewA"])
    {
        //ViewController2 *vc2=[navcon viewControllers][0];
        //navcon.navigationBarHidden=FALSE;
    }
    else if ([segue.identifier isEqualToString:@"ViewB"])
    {
        // UINavigationController *navcon=segue.destinationViewController;
        //ViewController1 *vc1=segue.destinationViewController;
    }
}


#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:
(UIPopoverController *)popoverController
{
    _menuPopoverController.delegate = nil;
    _menuPopoverController = nil;
}


- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    if (_menuPopoverController != nil &&
        _menuPopoverController.popoverVisible)
    {
        [_menuPopoverController dismissPopoverAnimated:YES];
        _menuPopoverController = nil;
    }
}

-(void)didPickCellAndStartSegue:(NSString *)segueIdentifier
{
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
    
    [_menuPopoverController dismissPopoverAnimated:YES];
    
}



@end