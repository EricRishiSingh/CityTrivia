//
//  ViewController.m
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import "ViewController.h"
#include "Questions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Background image
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk.jpg"]];
    [backgroundView setFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view insertSubview:backgroundView atIndex:0];
    
    // Navigation bar colour
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarStyle:UIBarStyleBlack];
    [bar setTintColor:[UIColor colorWithRed:100 green:100 blue:100 alpha:1.0]];
    
    // Set info button
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Info"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showInfo)];
    
    [self.navigationItem setRightBarButtonItem:infoButton];
    
}

- (void)evaluateResumeButtonEnabled
{
    NSInteger cachedValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"questionCount"];
    if (cachedValue > 0)
    {
        _resumeGame.enabled = YES;
        _resumeGame.alpha = 1;
    }
    else
    {
        _resumeGame.enabled = NO;
        _resumeGame.alpha = 0.5;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.ericsingh.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            [self.connectionLabel setText:@""];
            _startGame.enabled = YES;
            _startGame.alpha = 1;
            [self evaluateResumeButtonEnabled];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNREACHABLE!");
            [self.connectionLabel setText:@"Network connection must be enabled"];
            _startGame.enabled = NO;
            _startGame.alpha = 0.5;
            _resumeGame.enabled = NO;
            _resumeGame.alpha = 0.5;
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startGame"])
    {
        Questions *dest = [segue destinationViewController];
        dest.questionCount = 0;
    }
    
    if ([[segue identifier] isEqualToString:@"resumeGame"])
    {
        Questions *dest = [segue destinationViewController];
        NSInteger cachedValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"questionCount"];
        dest.questionCount = cachedValue;
    }
}

- (void)showInfo
{
    NSString *instructions = @"- Press the \"New Game\" button to start a new game. After the first city has been loaded you can start.\n\n-To play, you have to guess the missing characters (replaced with underscores). Type the full name in the text box and either press return or the \"Am I Correct\" button.\n\n-If you are having difficulty guessing the city, use the \"Hint\" button at the top right. The hint message has the option to reveal the answer.\n\n-Once a city is guessed correctly, an interesting fact is shown and you have the option to view the city on the map.\n\n-Use the picker to skip cities or move to a specific one.";
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Instructions"
                                message:instructions
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
