//
//  PlayerSummaryViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/2/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "PlayerSummaryViewController.h"
#import "PlayerMoreInfoTableViewController.h"
#import "Player.h"
#import "Logging.h"


@interface PlayerSummaryViewController()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *noImageAvailLabel;
@end

@implementation PlayerSummaryViewController
@synthesize spinner;
@synthesize noImageAvailLabel;

@synthesize player = _player;


- (void)processPlayerCardPhotoWithBlock:(void (^)(UIImage * imageData))block
{
    //NSURL *url = [AwsURLHelper getPlayers];
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("Player downloader", NULL);
	dispatch_async(downloadQueue, ^{
        UIImage *imageData = [Player playerCardPhoto: _player];
		dispatch_async(callerQueue, ^{
		    block(imageData);
		});
	});
	dispatch_release(downloadQueue);
}

- (void)setPlayer:(Player *)newplayer
{
    DLog(@"setPlayer: %@", newplayer);
    [_player release];
    _player = newplayer;
//    [fieldImage.image release];
    fieldImage.image = nil;
}


- (IBAction)photoButtonPressed:(id)sender
{
    DLog(@"photoButtonPressed");
    PlayerMoreInfoTableViewController *pmivc = [[PlayerMoreInfoTableViewController alloc] init];
    pmivc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pmivc.player = _player;
    
    UINavigationController *cntrol = [[UINavigationController alloc] initWithRootViewController:pmivc];
    [self presentViewController:cntrol animated:YES completion:nil];
    //[self.navigationController pushViewController:pmivc animated:YES];
    [cntrol release];
    [pmivc release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationItem.rightBarButtonItem.title = @"Photos";
        UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"More Info" style:UIBarButtonItemStyleBordered target:self action:@selector(photoButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rBarItem;
        [rBarItem release];
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [spinner startAnimating];
    
    DLog(@"playerSummaryViewController.viewDidLoad = %@", _player);
    NSString *s = [NSString stringWithFormat:@"%@ %@", _player.firstname, _player.lastname];
    [playerLabel setText:s]; //[player objectForKey:@"lastname"];
    playerNumber.text = _player.number;
    playerNickname.text = _player.nickname;
    // Do any additional setup after loading the view from its nib.
    DLog(@"viewWillAppear: player = %@", _player);
    if (fieldImage.image == nil) {
        
        [self processPlayerCardPhotoWithBlock:^(UIImage *imageData) {
            UIImage *image = imageData;
            fieldImage.image = image;
            if (image == nil) {
                noImageAvailLabel.hidden = FALSE;
            }
            [spinner stopAnimating];
        }];
    }
    
    NSDictionary *bImgs = [NSDictionary dictionaryWithObjectsAndKeys: 
                           @"11UClubTag", @"11UW", @"12UWhiteClubTag", @"12UW", @"12URedClubTag", @"12UR", @"13URedClubTag", @"13UR", nil];
    
    NSString *bName = [bImgs objectForKey:_player.level];
    DLog(@"bName = %@", bName);
    UIImage *bimg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bName ofType:@"png"]];
    if (bimg == nil)
        DLog(@"Failed to load banner for control vieww");
    banner.image = bimg;
}


- (void)viewDidUnload
{
    [self setSpinner:nil];
    [self setNoImageAvailLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [spinner release];
    [noImageAvailLabel release];
    [super dealloc];
}

@end
