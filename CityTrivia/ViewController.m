//
//  ViewController.m
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2013 Eric Singh. All rights reserved.
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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.00];
}

- (void)viewDidAppear:(BOOL)animated
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
    
    //[self checkInternetConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startGamePressed:(id)sender
{
    [self performSegueWithIdentifier:@"startGame" sender:self];
}

- (void)resumeGamePressed:(id)sender
{
    [self performSegueWithIdentifier:@"resumeGame" sender:self];
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

- (void)checkInternetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        _startGame.enabled = NO;
        _startGame.alpha = 0.5;
        [self showInternetConnectionError];
    }
}

- (void)showInternetConnectionError
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:@"Please verify network connection is active"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please verify network connection is active"
    //                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    // [alert show];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)infoButton:(id)sender
{
    NSString *instructions = @"- Press the \"New Game\" button to start a new game. After the first city has been loaded you can start.\n\n-To play, you have to guess the missing characters (replaced with underscores). Type the full name in the text box and either press return or the \"Am I Correct\" button.\n\n-If you are having difficulty guessing the city, use the \"Hint\" button at the top right. The hint message has the option to reveal the answer.\n\n-Once a city is guessed correctly, an interesting fact is shown and you have the option to view the city on the map.\n\n-Use the \"Go to City\" and stepper buttons to skip cities (levels).";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Instructions" message:instructions
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
}
@end
