//
//  MyClass.m
//  templateARC
//
//  Created by Mac Owner on 2/11/13.
//
//
#import "Player.h"

#import "RatePlayerViewController.h"

@implementation RatePlayerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.player.name;
    self.star1.tag=1;
    self.star2.tag=2;
    self.star3.tag=3;
    self.star4.tag=4;
    self.star5.tag=5;
}
- (IBAction)rateAction:(UIButton *)sender
{
    self.player.rating = sender.tag;
    [self.delegate ratePlayerViewController:self
                     didPickRatingForPlayer:self.player];
}
@end
