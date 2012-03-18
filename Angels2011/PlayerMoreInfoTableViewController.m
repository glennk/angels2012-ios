//
//  PlayerMoreInfoTableViewController.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/19/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "PlayerMoreInfoTableViewController.h"
#import "Parent.h"
#import "Logging.h"

@interface PlayerMoreInfoTableViewController()
@property (retain, nonatomic) IBOutlet UITableViewCell *headerCell;
@property (retain, nonatomic) IBOutlet UILabel *headerLabel;
@property (retain, nonatomic) IBOutlet UITableView *mainTable;
@property (retain, nonatomic) IBOutlet UITableViewCell *footerCell;
@property (retain, nonatomic) NSMutableArray *buttonIndexes;
@end


@implementation PlayerMoreInfoTableViewController
@synthesize headerCell;
@synthesize headerLabel;
@synthesize mainTable;
@synthesize footerCell;
@synthesize buttonIndexes;

@synthesize player = _player;

- (IBAction)doneButtonPressed:(id)sender
{
    DLog(@"Done button pressed");
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (self) {
//       // style = UITableViewStyleGrouped;
//        // Custom initialization
//        UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
//        self.navigationItem.rightBarButtonItem = rBarItem;
//        [rBarItem release];
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#define _NON_BLANK(a) (a != nil && [a length] > 0)

- (IBAction)sendMsgButton:(id)sender
{
    DLog(@"sendMsgButtonPressed");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Send a text message." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    buttonIndexes = [[[NSMutableArray alloc] init] retain];
    if (_NON_BLANK(_player.parents.phone1)) {
        [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"phone1 %@", _player.parents.phone1]];
        [buttonIndexes addObject: _player.parents.phone1];
    }
    if (_NON_BLANK(_player.parents.phone2)) {
        [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"phone2 %@",_player.parents.phone2]];
        [buttonIndexes addObject: _player.parents.phone2];
    }
    if (_NON_BLANK(_player.parents.email1)) {
        [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"email1 %@",_player.parents.email1]];
        [buttonIndexes addObject: _player.parents.email1];
    }
    if (_NON_BLANK(_player.parents.email2)) {
        [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"email2 %@",_player.parents.email2]];
        [buttonIndexes addObject: _player.parents.email2];
    }
    //    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView: self.view];
    [actionSheet release];
}

// Action sheet delegate method.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    DLog(@"actionSheet, button: %d", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [buttonIndexes release];
    }
    else {
        NSString *val = [buttonIndexes objectAtIndex:buttonIndex];
        DLog(@"val = %@", val);
        if (val != NULL) {
            val = [val stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSString* urlString = [NSString stringWithFormat: @"sms:%@", val];
            DLog(@"SMS #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rBarItem;
    [rBarItem release];

    [[NSBundle mainBundle] loadNibNamed:@"PlayerMoreInfo" owner:self options:nil];
    
    headerLabel.text = [NSString stringWithFormat:@"#%@  %@ %@", _player.number, _player.firstname, _player.lastname];
    
    self.tableView = mainTable;
    self.tableView.tableHeaderView = headerCell;
    self.tableView.tableFooterView = footerCell;

//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
//    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
//    headerLabel.text = [NSString stringWithFormat:@"#%@  %@ %@", _player.number, _player.firstname, _player.lastname];
//    headerLabel.textColor = [UIColor whiteColor];
//    headerLabel.shadowColor = [UIColor blackColor];
//    headerLabel.shadowOffset = CGSizeMake(0, 1);
//    headerLabel.font = [UIFont boldSystemFontOfSize:22];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    [containerView addSubview:headerLabel];
//    self.tableView.tableHeaderView = containerView;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setMainTable:nil];
    [self setHeaderCell:nil];
    [self setFooterCell:nil];
    [self setHeaderLabel:nil];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 6;
    }
    if (section == 2) {
        return 1;
    }
//    else {
//        return 1;
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"throws";
            cell.detailTextLabel.text = _player.throws;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"bats";
            cell.detailTextLabel.text = _player.bats;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"positions";
            cell.detailTextLabel.text = _player.positions;// @"Shortstop, Pitcher";
        }
    }
    if (indexPath.section == 1 && _player.parents != nil) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"parent";
            cell.detailTextLabel.text = _player.parents.name1;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"cell";
            cell.detailTextLabel.text = _player.parents.phone1; //@"512-657-4117";
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"email";
            cell.detailTextLabel.text = _player.parents.email1; //@"512-657-4117";
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"parent";
            cell.detailTextLabel.text = _player.parents.name2;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"cell";
            cell.detailTextLabel.text = _player.parents.phone2;
        }
        if (indexPath.row == 5) {
            cell.textLabel.text = @"email";
            cell.detailTextLabel.text = _player.parents.email2;
        }
    }
//    if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"Angels";
//            //           UILabel *label = [[UILabel alloc] init];
//            //cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
//            cell.detailTextLabel.numberOfLines = 3;
//            cell.detailTextLabel.text = @"Fall 2010\nSpring 2011\nFall 2011";
//            //[cell.contentView addSubview:label]; //detailTextLabel.lineBreakMode = label;
//        }
//    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 2)
//        return 100;
//    else
//        return 44;
//        
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Parent/Contact Info";
    }
//    if (section == 2) {
//        return @"Years in Angel's Program";
//    }
    return nil;
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
    if (indexPath.section == 1) {
        NSString *phone = nil;
        NSString *email = nil;
        switch (indexPath.row) {
            case 1:
                phone = _player.parents.phone1;
                break;
            case 2:
                email = _player.parents.email1;
                break;
            case 3:
                phone = _player.parents.phone1;
                break;
            case 4:
                email = _player.parents.email2;
                break;
            default:
                break;
        }
        
        if (phone != NULL) {
            phone = [phone stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSString* urlString = [NSString stringWithFormat: @"tel://%@", phone];
            DLog(@"Dialing #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        if (email != NULL) {
            email = [email stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSString* urlString = [NSString stringWithFormat: @"mailto://%@", email];
            DLog(@"Emailing #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

- (void)dealloc {
    [mainTable release];
    [headerCell release];
    [footerCell release];
    [headerLabel release];
    [super dealloc];
}

@end
