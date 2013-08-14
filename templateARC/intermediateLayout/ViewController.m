//
//  ViewController.m
//  intermediateLayout
//
//  Created by Mac Owner on 2/22/13.
//
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@end

@implementation ViewController

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

- (IBAction)nextButtonTapped:(id)sender
{
    
    
    
    static NSArray *albums;
    static NSArray *artists;
    if (artists == nil)
    {
        artists = @[ @"Thelonious Monk", @"Miles Davis", @"Louis Jordan & His Tympany Five",
        @"Charlie 'Bird' Parker", @"ChetBaker" ];
        }
    static int index = 0;
    static NSArray *texts;
    if (texts == nil)
    {
        texts = @[ @"Year:", @"Very Long Label Text:", @"ReleaseYear:" ];
        }
        self.releaseYearLabel.text = texts[index % 3];
        self.artistNameLabel.text = artists[index % 5];
        
    if (albums == nil)
    {
        albums = @[ @"The Complete Riverside Recordings",
        @"Live at the Blue Note" ];
    }
    self.albumValueLabel.text = albums[index % 2];
    index++;
        }

@end
