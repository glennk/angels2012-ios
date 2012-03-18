//
//  Coach4MoreInfoViewController.m
//  Angels2012
//
//  Created by Glenn Kronschnabl on 3/10/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "Coach4MoreInfoViewController.h"
#import "Logging.h"

@interface Coach4MoreInfoViewController()
@property (retain, nonatomic) IBOutlet UITableViewCell *headerCell;
@property (retain, nonatomic) IBOutlet UIImageView *headerCellImage;
@property (retain, nonatomic) IBOutlet UITableViewCell *footerCell;
@property (retain, nonatomic) IBOutlet UITableView *mainTable;

@property (retain, nonatomic) UIView *origView;
@property (retain, nonatomic) UIActivityIndicatorView *busyView;
@property (retain, nonatomic) NSMutableArray *buttonIndexes;
@property (retain, nonatomic) NSMutableArray *sections;
@end

@implementation Coach4MoreInfoViewController

@synthesize coach = _coach;

@synthesize headerCell;
@synthesize headerCellImage;
@synthesize footerCell;
@synthesize mainTable;
@synthesize origView, busyView;
@synthesize buttonIndexes;

@synthesize sections;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;

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

#define _NON_BLANK(a) (a != nil && [a length] > 0)

- (IBAction)sendMsgButtonPressed:(id)sender
{
    DLog(@"sendMsgButtonPressed");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Send a text message." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    buttonIndexes = [[[NSMutableArray alloc] init] retain];
    
    NSEnumerator *enumerator = [sections objectEnumerator];
    id dictobject;
    while ((dictobject = [enumerator nextObject])) {
        // each object is a dictionary
        NSEnumerator *keyEnumerator = [dictobject keyEnumerator];
        NSString *key;
        while ((key = [keyEnumerator nextObject])) {
            NSString *value = [dictobject valueForKey:key];
            DLog(@"key, value pair: %@, %@", key, value);
            [actionSheet addButtonWithTitle: [NSString stringWithFormat:@"%@ %@", key, [dictobject valueForKey:key]]];
            [buttonIndexes addObject: [dictobject valueForKey:key]];
        }
    }
    
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

/** Round Trip to server */
- (void)loadPhoto
{
    UIImage *image = _coach.photo;
    if (image)
        headerCellImage.image = image;
    [busyView stopAnimating];
    [self setView:origView];
    [busyView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"MainTable" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"HeaderCell" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"FooterCell" owner:self options:nil];

    
    UILabel *headerCellLabel = (UILabel*)[headerCell viewWithTag:1];
    NSString *fname = [NSString stringWithFormat:@"%@ %@", _coach.firstname, _coach.lastname];
    headerCellLabel.text = fname;

    self.tableView = mainTable;
    self.tableView.tableHeaderView = headerCell;
    
    /**
     * NSArray[0]
            NSDictionary[key=home] = '555.1212'
            NSDictionary[key=mobile] = '666.1212'
       NSArray[1]
            NSDictionary[key=email1] = 'bob@gmail.com'
            NSDictionary[key=email2] = 'dave@gmail.com'
     */
    sections = [[NSMutableArray alloc] init];
    
    if (_NON_BLANK(_coach.phone1) || _NON_BLANK(_coach.phone2)) {
        NSMutableDictionary *phone = [[NSMutableDictionary alloc] init];
        if (_NON_BLANK(_coach.phone1))
            [phone setObject:_coach.phone1 forKey:@"phone1"];
        if (_NON_BLANK(_coach.phone2))
            [phone setObject:_coach.phone2 forKey:@"phone2"];
        [sections addObject:phone];
        [phone release];
    }
        
    if (_NON_BLANK(_coach.email1) || _NON_BLANK(_coach.email2)) {
        NSMutableDictionary *email = [[NSMutableDictionary alloc] init];
        if (_NON_BLANK(_coach.email1))
            [email setObject:_coach.email1 forKey:@"email1"];
        if (_NON_BLANK(_coach.email2))
            [email setObject:_coach.email2 forKey:@"email2"];
        [sections addObject:email];
        [email release];
    }

    DLog(@"sections = %@", sections);
    
    if (sections.count > 0)
        self.tableView.tableFooterView = footerCell;
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setHeaderCell:nil];
    [self setFooterCell:nil];
    [self setMainTable:nil];
    [self setHeaderCellImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    origView = [self.view retain];

    busyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self setView:busyView];
    [busyView startAnimating];
    [self performSelectorInBackground:@selector(loadPhoto) withObject:nil];
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
    NSInteger n = sections.count;
    DLog(@"numberOfSectionsInTableView.n = %d", n);
    return n;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = [[sections objectAtIndex:section] count];
    DLog(@"numberOfRowsInSection.n = %d", n);
    return n;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    // Configure the cell...
    NSDictionary *dict = [sections objectAtIndex:indexPath.section];
    NSString *key = [[dict allKeys] objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    NSString *label = [[dict allValues] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = label;
    
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"mobile";
//                cell.detailTextLabel.text = _coach.phone1; //@"512-555-1212";
//                break;
//            case 1:
//                cell.textLabel.text = @"home";
//                cell.detailTextLabel.text = _coach.phone2; //@"512-555-2222";
//                break;
//            default:
//                break;
//        }
//    }
//    if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"email";
//                cell.detailTextLabel.text = _coach.email1; //@"david@gmail.com";
//                break;
//            case 1:
//                cell.textLabel.text = @"email";
//                cell.detailTextLabel.text = _coach.email2; //@"info@austinangelsbaseball.com";
//                break;
//            default:
//                break;
//        }
//    }
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
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
    if (indexPath.section == 0) {
        DLog(@"indexPath = %@", indexPath);
        NSString *phone = nil;
        switch (indexPath.row) {
            case 0:
                phone = _coach.phone1;
                break;
            case 1:
                phone = _coach.phone2;
                break;
        }
        if (phone != NULL) {
            phone = [phone stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSString* urlString = [NSString stringWithFormat: @"tel://%@", phone];
            DLog(@"Dialing #: %@", urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
    if (indexPath.section == 1) {
        DLog(@"indexPath = %@", indexPath);
        NSString *email = nil;
        switch (indexPath.row) {
            case 0:
                email = _coach.email1;
                break;
            case 1:
                email = _coach.email2;
                break;
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
    [headerCell release];
    [footerCell release];
    [mainTable release];
    [headerCellImage release];
    [super dealloc];
}

@end
