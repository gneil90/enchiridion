//
//  SidebarViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/23/13.
//
//

#import "SidebarViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [sender exerciseAmbiguityInLayout];
}

@end
