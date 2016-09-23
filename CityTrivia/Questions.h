//
//  Questions.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2013 Eric Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Questions : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    UIView *mask;
}

@property (nonatomic) NSUInteger questionCount;
@property (nonatomic) NSMutableArray *cityArray;
@property (nonatomic) NSString *currentCity;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateQuestion;
@property (weak, nonatomic) IBOutlet UITextField *answer;
//@property (weak, nonatomic) IBOutlet UIButton *goToCity;
//@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic, retain) IBOutlet UIPickerView *cityPickerView;

//- (IBAction)evaluateQuestionPressed:(id)sender;
//- (IBAction)goToCityPressed:(id)sender;

@end
