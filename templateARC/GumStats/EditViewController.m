
#import "EditViewController.h"

@interface EditViewController () <UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic,weak) IBOutlet UIButton *deleteButton;
@end

@implementation EditViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.textField.text = [NSString stringWithFormat:@"%d", self.value];
	//[self.textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//viewDidAppear: is actually called twice for EditViewController. Because the segue
//temporarily puts the view into the source view for the animation, UIKit calls
//viewDidAppear: to let the view controller know about this. But when the segue calls
//presentViewController after the animation completes, UIKit calls viewDidAppear:
//again.
//It is not safe to show the keyboard on the first call to viewDidAppear:, but it is fine
//the second time around, because at that point the segue has finished its animation.
//You can check for this by looking at the self.presentingViewController property,
//which is nil before but non-nil after the call to presentViewController.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.presentingViewController != nil)
    {
        [self.textField becomeFirstResponder];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DoneEdit"])
    {
        self.value = [self.textField.text intValue];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@"DoneEdit"])
    {
        if ([self.textField.text length] > 0)
        {
            int value = [self.textField.text intValue];
            if (value >= 0 && value <= 100)
                return YES;
        }
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:@"Value must be between 0 and 100."
          delegate:nil
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil]
         show];
        return NO;
    }
    return YES;
}

- (IBAction)delete:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Really delete?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete"
                                  otherButtonTitles:nil];
    [actionSheet showFromRect:self.deleteButton.frame
                       inView:self.view animated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"DeleteValue"
                                  sender:nil];
    }
}

@end
