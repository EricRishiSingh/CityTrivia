//
//  Questions.m
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import "Questions.h"
#import "City.h"
#import "CityMapViewController.h"

@interface Questions ()

@end

@implementation Questions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCsvData
{
    // Get csv data
    NSError *error = nil;
    NSString *absoluteURL = @"http://www.intelligentdreams.ca/citytriviaV2.0/citytrivia.csv";
    NSURL *url = [NSURL URLWithString:absoluteURL];
    NSString *fileString = [[NSString alloc] initWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    // Handle error
    if (error)
    {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Error"
                                    message:@"Cannot load questions. Please contact: support@ericsingh.com"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        [activityIndicator stopAnimating];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else
    {
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
        
        [activityIndicator stopAnimating];
        [mask setHidden:YES];
        
        // Load city picker after csv file is loaded
        [self.cityPickerView reloadAllComponents];
        
        [self loadNextQuestion];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Grey out screen
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    [self.view addSubview:mask];
    
    // Add background image
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk.jpg"]];
    [backgroundImage setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view insertSubview:backgroundImage atIndex:0];
    
    // Set hint button
    UIBarButtonItem *hintButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Hint"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showHintMessage)];
    
    [self.navigationItem setRightBarButtonItem:hintButton];
    
    // The answer text field delegate
    _answerTextField.delegate = self;
    
    // Disable autocorrect
    _answerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Declare delegate and dataSource
    self.cityPickerView.delegate = self;
    self.cityPickerView.dataSource = self;
    
    // Animate activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self performSelector:@selector(getCsvData) withObject:nil afterDelay:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setTitle:[@"City " stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)_questionCount]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [[NSUserDefaults standardUserDefaults] setInteger:_questionCount - 1 forKey:@"questionCount"];
    }
}

- (IBAction)nextQuestionPressed:(id)sender {
    [self loadNextQuestion];
}

- (void)loadNextQuestion
{
    if (_cityArray != nil && _questionCount < _cityArray.count)
    {
        [_answerTextField setText:@""];
        [_nextQuestionButton setEnabled:NO];
        [_factButton setEnabled:NO];
        [_evaluateQuestionButton setEnabled:YES];
        [_factTextField setText:@""];
        
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
        
        [_cityPickerView selectRow:_questionCount inComponent:0 animated:YES];
        _questionCount++;
        [self setTitle:[@"City " stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)_questionCount]]];
    }
    else
    {
        _questionCount = 0;
        [self loadNextQuestion];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self evalQuestion];
    return YES;
}

- (IBAction)evaluateQuestionPressed:(id)sender
{
    [self evalQuestion];
}

- (void)evalQuestion
{
    [_answerTextField resignFirstResponder];
    NSString *result = [[_answerTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    NSString *expectedResult = city.name;
    
    if ([result caseInsensitiveCompare:expectedResult] == NSOrderedSame)
    {
        [self showAnswer];
    }
    else
    {
        [self showTryAgain];
    }
}

- (void)showTryAgain
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Incorrect"
                                message:@"You are incorrect. Please try again"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[self getOkButton: false]];
    [self presentViewController:alert animated:YES completion:nil];
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
    
    [alert addAction:[self getOkButton: false]];
    [alert addAction:answerButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAnswer
{
    City *city = [_cityArray objectAtIndex:_questionCount - 1];
    [_cityLabel setText:city.name];
    [_factTextField setText:city.fact];
    [_nextQuestionButton setEnabled:YES];
    [_factButton setEnabled:YES];
    [_evaluateQuestionButton setEnabled:NO];
    _currentCity = city.name;
}

-(UIAlertAction*)getOkButton: (Boolean) loadNextQuestion
{
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 if (loadNextQuestion)
                                     [self loadNextQuestion];
                             }];
    
    return action;
}

- (IBAction)loadMap:(id)sender {
    CityMapViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CityMapView"];
    view.cityName = _currentCity;
    [self.navigationController pushViewController:view animated:YES];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row >= 0 && row <= _cityArray.count)
    {
        _questionCount = row;
        [self loadNextQuestion];
    }
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (int)_cityArray.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"City %.0ld", (long)row + 1];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

@end
