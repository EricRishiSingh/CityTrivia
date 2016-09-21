//
//  Questions.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2013 Eric Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Questions : UIViewController <UITextFieldDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    UIView *mask;
}

//@property (strong, nonatomic) NSMutableArray *images;
@property (nonatomic) NSUInteger questionCount;
//@property (nonatomic) NSUInteger counter;
@property (nonatomic) NSUInteger imageCount;
@property (nonatomic) NSMutableArray *cityArray;
@property (nonatomic) NSString *currentCity;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateQuestion;
@property (weak, nonatomic) IBOutlet UITextField *answer;
@property (weak, nonatomic) IBOutlet UIButton *goToCity;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

- (IBAction)evaluateQuestionPressed:(id)sender;
- (IBAction)goToCityPressed:(id)sender;

@end
