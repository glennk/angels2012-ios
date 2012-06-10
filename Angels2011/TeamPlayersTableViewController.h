//
//  PlayersTableViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Team.h"

@interface TeamPlayersTableViewController : UITableViewController <MFMessageComposeViewControllerDelegate, UIAlertViewDelegate> {
    NSArray *players;
    Team *team;
}

@property (retain, nonatomic) NSArray *players;
@property (retain, nonatomic) Team *team;

@end
