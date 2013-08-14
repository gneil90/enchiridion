//
//  ViewController.m
//  storyBoardSample
//
//  Created by Mac Owner on 2/8/13.
//
//

#import "GestureViewController.h"
#import "AppDelegate.h"
#import "Player.h"
@interface GestureViewController ()

@end

@implementation GestureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Gesture Segue invoke");
    if([segue.identifier isEqualToString:@"BestPlayers"])
    {
        UINavigationController *navCon=segue.destinationViewController;
        navCon.navigationBar.tintColor=[UIColor darkGrayColor];
        RankingViewController *rankingVC=[navCon viewControllers][0];
        rankingVC.delegate=self;
        rankingVC.view.backgroundColor=[UIColor lightGrayColor];
        AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
        if ((self.players!=nil)&&(self.bestPlayers!=nil))
        {
            self.players=nil;
            self.bestPlayers=nil;
        }
        self.players=appDelegate.players;
        
        //если не выделить память, некуда будет добавлять объекты в цикле
        self.bestPlayers=[[NSMutableArray alloc]init];
        
        
        for (Player *playerFromArray in self.players)
        {
            if (playerFromArray.rating>3)
            {
                [self.bestPlayers addObject:playerFromArray];
            }
        }
        rankingVC.rankedPlayers=self.bestPlayers;
        rankingVC.rankState=kBestState;

    }
    else if ([segue.identifier isEqualToString:@"WorstPlayers"])
    {
        UINavigationController *navCon=segue.destinationViewController;
        navCon.navigationBar.tintColor=[UIColor darkGrayColor];
        RankingViewController *rankingVC=[navCon viewControllers][0];
        rankingVC.delegate=self;
        AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
        if (self.players!=nil) self.players=nil;
        self.players=appDelegate.players;
        
        self.worstPlayers=[[NSMutableArray alloc]init];
        
        for (Player *playerFromArray in self.players)
        {
            if (playerFromArray.rating<3)
            {
                [self.worstPlayers addObject:playerFromArray];
            }
        }
        rankingVC.rankedPlayers=self.worstPlayers;
        rankingVC.rankState=kWorstState;
        

    }
}
-(void)donePressed:(RankingViewController *)controller
{
    controller.rankedPlayers=nil;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
