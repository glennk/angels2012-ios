//
//  PlayerMoreInfoTableViewController.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/19/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "PlayerMoreInfoTableViewController.h"
#import "Parent.h"

@implementation PlayerMoreInfoTableViewController

@synthesize player = _player;

- (IBAction)doneButtonPressed:(id)sender
{
    NSLog(@"Done button pressed");
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
       // style = UITableViewStyleGrouped;
        // Custom initialization
        UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rBarItem;
        [rBarItem release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
    headerLabel.text = [NSString stringWithFormat:@"#%@  %@ %@", _player.number, _player.firstname, _player.lastname];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerLabel];
    self.tableView.tableHeaderView = containerView;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    else {
        return 1;
    }
}

//- (NSString *)parentName:(Parent *)p
//{
//    NSString *f = (p.firstname != NULL) ? p.firstname : @"";
//    NSString *l = (p.lastname != NULL) ? p.lastname : @"";
//    return [NSString stringWithFormat:@"%@ %@", f, l];
//}

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
    if (indexPath.section == 1) {
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
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Angels";
            //           UILabel *label = [[UILabel alloc] init];
            //cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.text = @"Fall 2010\nSpring 2011\nFall 2011";
            //[cell.contentView addSubview:label]; //detailTextLabel.lineBreakMode = label;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return 100;
    else
        return 44;
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Parent/Contact Info";
    }
    if (section == 2) {
        return @"Years in Angel's Program";
    }
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
            NSLog(@"Dialing #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        if (email != NULL) {
            email = [email stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSString* urlString = [NSString stringWithFormat: @"mailto://%@", email];
            NSLog(@"Emailing #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

@end
