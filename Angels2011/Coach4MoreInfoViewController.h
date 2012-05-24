//
//  Coach4MoreInfoViewController.h
//  Angels2012
//
//  Created by Glenn Kronschnabl on 3/10/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface Coach4MoreInfoViewController : UITableViewController <UIActionSheetDelegate>

@property (retain, nonatomic) Coach *coach;
@property (retain, nonatomic) UIImage *picture;

- (IBAction)sendMsgButtonPressed:(id)sender;
@end
