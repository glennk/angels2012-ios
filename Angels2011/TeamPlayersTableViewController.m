//
//  PlayersTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "TeamPlayersTableViewController.h"
#import "PlayerSummaryViewController.h"
#import "Team.h"
#import "Player.h"
#import "Logging.h"

@interface TeamPlayersTableViewController()
@property (retain, nonatomic) UIView * origView;
@property (retain, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation TeamPlayersTableViewController

@synthesize players = _players;
@synthesize team = _team;
@synthesize origView, spinner;


- (void)loadTeamPlayers
{
    if (!_players) {
        //sleep(5);
        _players = [[Player teamPlayers: self.team] retain];
        [spinner stopAnimating];
        
        [self setView: origView];
        [self.tableView reloadData];
        
        [spinner release];
    }
}

- (void)setTeam:(Team *)newTeam
{
    DLog(@"setTeam()");
    if (_team != newTeam) {
        _team = newTeam;
    }
    self.title = _team.name;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    origView = [self.view retain];
    
    [self setView:spinner];
    [self performSelectorInBackground:@selector(loadTeamPlayers) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [self.players count];
}

- (Player *)playerAtIndexPath:(NSIndexPath *)indexPath
{
    Player *p = [self.players objectAtIndex:indexPath.row];
    DLog(@"p = %@", p);
   return p;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AngelPlayersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Player *p = [self playerAtIndexPath:indexPath];
    NSString *s = [NSString stringWithFormat:@"%@ %@", p.firstname, p.lastname];
    cell.textLabel.text = s;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    PlayerSummaryViewController *psvc = [[PlayerSummaryViewController alloc] init];
    psvc.player = [self playerAtIndexPath:indexPath];
    [self.navigationController pushViewController:psvc animated:YES];
    [psvc release];    
}

@end
