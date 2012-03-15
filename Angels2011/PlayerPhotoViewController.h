//
//  PlayerViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerPhotoViewController : UIViewController {
    Player *player;
    
    UILabel *playerLabel;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *playerPhoto;
}

@property (retain, nonatomic) Player *player;

@property (retain) IBOutlet UILabel *playerLabel;

//@property (retain) IBOutlet UIScrollView *scrollView;
//@property (retain) IBOutlet UIImageView *playerPhoto;

@end
