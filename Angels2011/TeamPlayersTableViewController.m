//
//  PlayersTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "TeamPlayersTableViewController.h"
#import "PlayerSummaryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Team.h"
#import "Player.h"
#import "Logging.h"

@interface TeamPlayersTableViewController()
@property (retain, nonatomic) IBOutlet UITableViewCell *headerCell;
@property (retain, nonatomic) IBOutlet UIButton *customButton;
- (IBAction)sendTeamText:(id)sender;
@property (retain, nonatomic) NSDictionary *banners;
@property (retain, nonatomic) UIImageView *banner;
@end

@implementation TeamPlayersTableViewController
@synthesize headerCell;
@synthesize customButton;

@synthesize players = _players;
@synthesize team = _team;
@synthesize banners = _banners;
@synthesize banner = _banner;


- (void)loadRESTWithBlock:(void (^)(NSArray * restData))block
{
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("rest downloader", NULL);
	dispatch_async(downloadQueue, ^{
        NSArray *restData = [[Player teamPlayers: self.team] retain];
		dispatch_async(callerQueue, ^{
		    block(restData);
		});
	});
	dispatch_release(downloadQueue);
}


- (IBAction)sendTeamText:(id)sender
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText]) {
//        controller.body = @"Hello from ...";
        NSMutableArray *smsTo = [[NSMutableArray alloc] init];
        for (Player *p in _players) {
            if (p.parents.phone1 && [p.parents.phone1 length] > 0) {
                 [smsTo addObject: p.parents.phone1];
            }
            if (p.parents.phone1 && [p.parents.phone2 length] > 0) {
                [smsTo addObject: p.parents.phone2];
            }
        }
//            controller.recipients = smsTo;
        controller.recipients = [NSArray arrayWithObjects:@"(512)657-4117", @"(512)705-6639", @"(512)977-3501", nil];
        controller.messageComposeDelegate = self;
        [self  presentModalViewController:controller animated:YES];
        [smsTo release];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//			[alert show];
//			[alert release];
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)setTeam:(Team *)newTeam
{
    DLog(@"setTeam()");
    if (_team != newTeam) {
        _team = newTeam;
    }
    //self.title = _team.name;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TeamBannerImages" ofType:@"plist"];
    _banners = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
    
    // Create and set the table header view.
    if (headerCell == nil) {
        _banner = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 54.0)] autorelease];
        
//        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bob"] autorelease];
//        [cell.contentView  addSubview:photo];
//        UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0., 45, 300, 80)] autorelease];
//        [button setTitle:@"Team Text" forState: UIControlStateNormal];
//        [cell.contentView addSubview:button];
        self.tableView.tableHeaderView = _banner;
        

//        [[NSBundle mainBundle] loadNibNamed:@"TeamPlayersHeaderView" owner:self options:nil];
//        self.tableView.tableFooterView = headerCell;

//        [customButton setTitle:@"Team Text" forState: UIControlStateNormal];
//        [[customButton layer] setCornerRadius:8.0f];
//        [[customButton layer] setMasksToBounds: TRUE];
//        [[customButton layer] setBorderWidth: 1.0f];
//        [[customButton layer] setBackgroundColor:[[UIColor redColor] CGColor]];
//        self.tableView.allowsSelectionDuringEditing = YES;
    }

//    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bob"] autorelease];
//    cell.textLabel.text = @"Team Text";
//    self.tableView.tableFooterView = cell;

//    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
//    //[containerView setBackgroundColor:[UIColor grayColor]];
//    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(20, 10, 280, 30)] autorelease];
//    [button setTitle:@"Team Text" forState: UIControlStateNormal];
//    [[button layer] setCornerRadius:8.0f];
//    [[button layer] setMasksToBounds: TRUE];
//    [[button layer] setBorderWidth: 1.0f];
//    [[button layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
//    [containerView addSubview:button];
//    self.tableView.tableFooterView = containerView;    
}

- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [self setHeaderCell:nil];
    [self setCustomButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_players) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0., 0., 40., 40.);
        spinner.center = self.view.center;
        [self.view addSubview:spinner];
        
        [spinner startAnimating];
        
        [self loadRESTWithBlock:^(NSArray *restData) {
            _players = [restData copy];
            
            [self.tableView reloadData];
            [spinner stopAnimating];
            [spinner release];
        }];

    }
    DLog(@"_team.level = %@", _team);
    NSString *bName = [_banners objectForKey:_team.level];
    DLog(@"bName = %@", bName);
    UIImage *bimg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bName ofType:@"png"]];
    if (bimg == nil)
        DLog(@"Failed to load banner for control vieww");
    _banner.image = bimg;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"%d", [self.players count]);
    if ([_players count] > 0)
        return [self.players count]+1;
    else
        return 0;
}

- (Player *)playerAtIndexPath:(NSIndexPath *)indexPath
{
    Player *p = [self.players objectAtIndex:indexPath.row];
  //  DLog(@"p = %@", p);
   return p;
}

#define _NON_BLANK(a) (a != nil && [a length] > 0)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AngelPlayersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    DLog(@"indexPath.row = %d", indexPath.row);
    if (indexPath.row == [self.players count]) {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Text entire team";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = [UIImage imageNamed:@"112-group.png"];
    }
    else {
        Player *p = [self playerAtIndexPath:indexPath];
        NSString *s = nil;
        s = [NSString stringWithFormat:@"%@ %@", p.firstname, p.lastname];
        cell.textLabel.text = s;
        if (_NON_BLANK(p.nickname))
            s = [NSString stringWithFormat:@"#%@, %@", p.number, p.nickname];
        else
            s = [NSString stringWithFormat:@"#%@", p.number];
        cell.detailTextLabel.text = s;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = nil;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_players count]) {
        [self sendTeamText:nil];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    }
    else {
        PlayerSummaryViewController *psvc = [[PlayerSummaryViewController alloc] init];
        psvc.player = [self playerAtIndexPath:indexPath];
        [self.navigationController pushViewController:psvc animated:YES];
        [psvc release];
    }
}

- (void)dealloc {
    [headerCell release];
    [customButton release];
    [super dealloc];
}
@end
