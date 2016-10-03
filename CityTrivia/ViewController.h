//
//  ViewController.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *resumeGame;
@property (weak, nonatomic) IBOutlet UIButton *startGame;
@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;

@end
