//
//  CityMapViewController.m
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-30.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import "CityMapViewController.h"

@interface CityMapViewController ()

@end

@implementation CityMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mapView];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error)
    {
        CLLocationCoordinate2D coords;
        
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            coords.latitude = placemark.location.coordinate.latitude;
            coords.longitude = placemark.location.coordinate.longitude;
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
            MKCoordinateRegion region = MKCoordinateRegionMake(coords, span);
            [mapView setRegion:region animated:YES];
        }
        
    };
    
    [geocoder geocodeAddressString:_cityName completionHandler:completionHandler];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
