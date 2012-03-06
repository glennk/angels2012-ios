//
//  PlayerSummaryViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/2/11.
//  Copyright 2011 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerSummaryViewController : UIViewController {
    Player *player;
    
    IBOutlet UILabel *playerLabel;
    IBOutlet UILabel *playerNumber;
    IBOutlet UILabel *playerNickname;
    IBOutlet UIImageView *fieldImage;
    IBOutlet UIImageView *banner;
    //IBOutlet UIView *fieldOverlay;
}

//@property (copy) NSString *player;
@property (retain, nonatomic) Player *player;

- (IBAction)photoButtonPressed:(id)sender;

@end
