//
//  SecondViewController.m
//  MapTab
//
//  Created by optimusmac-12 on 22/07/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomAnnotation.h"
@interface SecondViewController () <CLLocationManagerDelegate>

@end

@implementation SecondViewController
@synthesize mapsView;
CLLocationManager *manager;
CLGeocoder *geocoder;
CLPlacemark *placemark;


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [mapsView setDelegate:self];
    [[self mapsView] setShowsUserLocation:YES];
    manager = [[CLLocationManager alloc] init];
    
    geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    
    // we have to setup the location maanager with permission in later iOS versions
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    MKCoordinateRegion bigBen = { {0.0, 0.0} , {0.0, 0.0} };
    bigBen.center.latitude = 51.50063;
    bigBen.center.longitude = -0.124629;
    bigBen.span.longitudeDelta = 0.02f;
    bigBen.span.latitudeDelta = 0.02f;
    [mapsView setRegion:bigBen animated:YES];
    
    CustomAnnotation *ann1 = [[CustomAnnotation alloc] init];
    ann1.title = @"Big Ben";
    ann1.subtitle = @"London";
    ann1.coordinate = bigBen.center;
    [mapsView addAnnotation: ann1];
    
   }
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorPurple;
    
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    
    MyPin.rightCalloutAccessoryView = advertButton;
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    
    return MyPin;
}

-(void)button:(id)sender
{
    
    CLLocation *ourcoordinate=[[CLLocation alloc] initWithLatitude:51.50063 longitude:-0.124629];
    
    
    [geocoder reverseGeocodeLocation:ourcoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            _address = [NSString stringWithFormat:@"%@\n%@ %@\n%@\n%@",
                        placemark.thoroughfare,
                        placemark.postalCode, placemark.locality,
                        placemark.administrativeArea,
                        placemark.country];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Address"
                                                              message:_address
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];

            
        }
        else {
            
            NSLog(@"%@", error.debugDescription);
            
        }
        
    } ];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:
            mapsView.mapType=MKMapTypeStandard;
            break;
        case 1:
            mapsView.mapType=MKMapTypeSatellite;
            break;
        case 2:
            mapsView.mapType=MKMapTypeHybrid;
            break;
        default:
            break;
    }
}
@end
