//
//  Questions.m
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2013 Eric Singh. All rights reserved.
//

#import "Questions.h"
#import "City.h"
#import "CityMapViewController.h"

@interface Questions ()

@end

@implementation Questions

@synthesize evaluateQuestion;
@synthesize goToCity;
@synthesize answer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCsvData
{
    // Get csv data
    NSError *error = nil;
    NSString *absoluteURL = @"http://www.ericsingh.com/citytriviaV2.0/citytrivia.csv";
    NSURL *url = [NSURL URLWithString:absoluteURL];
    NSString *fileString = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    NSMutableArray *citiesFromCsv = (NSMutableArray*)[fileString componentsSeparatedByString:@"\r"];
    
    _cityArray = [NSMutableArray new];
    _cityArray = [[NSMutableArray alloc] initWithCapacity:citiesFromCsv.count];
    
    for(id city in citiesFromCsv)
    {
        
        NSArray *cityObjects = [city componentsSeparatedByString:@","];
        
        if (cityObjects.count == 3)
        {
            City *newCity = [[City alloc] init];
            newCity.name = [cityObjects objectAtIndex:0];
            newCity.fact = [cityObjects objectAtIndex:1];
            newCity.firstHint = [cityObjects objectAtIndex:2];
            [_cityArray addObject:newCity];
        }
    }
    
    _stepper.maximumValue = _cityArray.count;
    _stepper.minimumValue = 1;
    [activityIndicator stopAnimating];
    [mask setHidden:YES];
    [self loadNextQuestion];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Grey out screen
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    [self.view addSubview:mask];
    
    // Add background image
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image1.jpg"]];
    [backgroundImage setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view insertSubview:backgroundImage atIndex:0];
    
    // Set hint button
    UIBarButtonItem *hintButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Hint"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showHintMessage)];
    
    self.navigationItem.rightBarButtonItem = hintButton;
    
    // The answer text field delegate
    answer.delegate = self;
    
    // Disable autocorrect
    answer.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Animate activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self performSelector:@selector(getCsvData) withObject:nil afterDelay:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [[NSUserDefaults standardUserDefaults] setInteger:_questionCount - 1 forKey:@"questionCount"];
    }
}

- (void)loadNextQuestion
{
    if (_cityArray != nil && _questionCount < _cityArray.count)
    {
        [answer setText:@""];
        
        City *city = [_cityArray objectAtIndex:_questionCount];
        NSString *cityName = city.name;
        NSMutableString *cityNameModified = [[NSMutableString alloc] init];
        [cityNameModified setString:cityName];
        NSInteger cityLength = cityName.length;
        
        for (int i = 1; i < cityLength - 1; i++) {
            if (NSEqualRanges([[cityNameModified substringWithRange:NSMakeRange(i, 1)] rangeOfString:@" "], NSMakeRange(NSNotFound, 0)))
            {
                [cityNameModified setString:[cityNameModified stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"_"]];
            }
            
            if (i % 2 == 0) {
                i = i + 2;
            }
        }
        
        
        _cityLabel.text = cityNameModified;
        _questionCount++;
        
        _stepper.value = _questionCount;
        [goToCity setTitle:[@"Go to City " stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)_questionCount]] forState:UIControlStateNormal];
        self.navigationItem.title = [@"City " stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)_questionCount]];
    }
    else
    {
        _questionCount = 0;
        [self loadNextQuestion];
    }
}


- (IBAction)evaluateQuestionPressed:(id)sender
{
    [self evalQuestion];
}

- (void)evalQuestion
{
    [answer resignFirstResponder];
    NSString *result = [[answer text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    NSString *expectedResult = city.name;
    
    if ([result caseInsensitiveCompare:expectedResult] == NSOrderedSame)
    {
        [self showFact];
    }
    else
    {
        [self showTryAgain];
    }
}

- (void)showFact
{
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    _currentCity = city.name;
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:city.name
                                message:city.fact
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* mapButton = [UIAlertAction
                                actionWithTitle:@"Show City on Map"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self loadNextQuestion];
                                    [self loadMap];
                                }];
    
    [alert addAction:[self getOkButton]];
    [alert addAction:mapButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showTryAgain
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"You are incorrect. Please try again"
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
    
    alert.tag = 3;
    [alert show];
}

- (void)showHintMessage
{
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Here's a Hint"
                                message:city.firstHint
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* answerButton = [UIAlertAction
                                   actionWithTitle:@"Give me the Answer"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self showAnswer];
                                   }];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Here's a Hint" message:city.firstHint
    //                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Give me the Answer", nil];
    
    //    alert.tag = 4;
    //    [alert show];
    
    [alert addAction:okButton];
    [alert addAction:answerButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAnswer
{
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:city.name message:nil
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    alert.tag = 5;
    [alert show];
}

-(UIAlertAction*)getOkButton
{
    return [UIAlertAction
            actionWithTitle:@"Ok"
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
                [self loadNextQuestion];
            }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // NO = 0, YES = 1
    if(buttonIndex == 0)
    {
        if (alertView.tag == 1)
        {
            [self loadNextQuestion];
        }
        if (alertView.tag == 2)
        {
            [self loadNextQuestion];
        }
        if (alertView.tag == 5)
        {
            [self loadNextQuestion];
        }
    }
    else
    {
        if (alertView.tag == 1)
        {
            [self loadNextQuestion];
            [self loadMap];
        }
        if (alertView.tag == 4)
        {
            [self showAnswer];
        }
    }
}

- (void)loadMap
{
    CityMapViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CityMapView"];
    view.cityName = _currentCity;
    [self.navigationController pushViewController:view animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self evalQuestion];
    return YES;
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    if (value > 0 && value <= _cityArray.count)
    {
        [goToCity setTitle:[@"Go to City " stringByAppendingString:[NSString stringWithFormat:@"%.0f", value]] forState:UIControlStateNormal];
    }
}

- (IBAction)goToCityPressed:(id)sender
{
    _questionCount = _stepper.value - 1;
    [self loadNextQuestion];
}


@end
