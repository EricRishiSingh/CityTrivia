//
//  CityMapViewController.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-30.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CityMapViewController : UIViewController
{
    MKMapView *mapView;
}

@property (nonatomic) NSString *cityName;

@end
