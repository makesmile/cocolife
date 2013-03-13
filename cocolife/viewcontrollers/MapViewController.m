//
//  MapViewController.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

-(void) initialize{
    firstLoad = YES;
    [self setNaviTitle];
    [self setMapView];
    [self setIcon];
    [self setPaper];
    [self createLocationManager];
}

-(void) createLocationManager{
    locationManger = [[CLLocationManager alloc] init];
    [locationManger setDelegate:self];
    [locationManger setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManger.distanceFilter = 20.0;
}
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0){
    [mapView_ animateToLocation:newLocation.coordinate];
}

-(void) startLocation{
    [locationManger startUpdatingLocation];
}

-(void) stopLocation{
    [locationManger stopUpdatingLocation];
}

-(void) setNaviTitle{
    UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapTitle"]];
    self.navigationItem.titleView = titleImage;
}

-(void) setMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.664035
                                                            longitude:139.698212
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.frame = [self viewFrame];
    mapView_.delegate = self;
    [self.view addSubview:mapView_];
}

-(void) setIcon{
    // ホームへ戻る
    UIButton *homeB = [UIButton buttonWithType:UIButtonTypeCustom];
    homeB.frame = CGRectMake(5, 5, 29.5f, 40);
    [homeB setBackgroundImage:[UIImage imageNamed:@"mapHome"] forState:UIControlStateNormal];
    [homeB addTarget:self action:@selector(toHome) forControlEvents:UIControlEventTouchUpInside];
    [mapView_ addSubview:homeB];
}

-(void) setPaper{
    mapPaperView = [[MapPaperView alloc] init];
    [mapView_ addSubview:mapPaperView];
    mapPaperView.onPaperTap = ^(Coco* coco){
        if(onSelectCoco)
            onSelectCoco(self, coco);
    };
    
    [self hidePaper];
}

-(void) toHome{
    CLLocation* currentLocation = mapView_.myLocation;
    [mapView_ animateToLocation:currentLocation.coordinate];
}

-(void) showPaper{
    
    CGRect fromFrame = mapPaperView.frame;
    fromFrame.origin.y = mapView_.frame.size.height;
    mapPaperView.frame = fromFrame;
    
    CGRect toFrame = mapPaperView.frame;
    toFrame.origin.y = mapView_.frame.size.height - 80;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
	mapPaperView.frame = toFrame;
	[UIView commitAnimations];
}

-(void) hidePaper{
    CGRect paperFrame = mapPaperView.frame;
    paperFrame.origin.y = mapView_.frame.size.height;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
    mapPaperView.frame = paperFrame;
    [UIView commitAnimations];
}

// ▼ public ====================================

-(void) assignModel:(CocoList*)cocoList_{
    cocoList = cocoList_;
}

-(CLLocation*) homeLocation{
    return mapView_.myLocation;
}

-(void) update{
    [mapView_  clear];
    for(int i=0,max=[cocoList count];i<max;i++){
        Coco* coco = (Coco*)[cocoList get:i];
        GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
        options.userData = coco;
        options.position = CLLocationCoordinate2DMake(coco.lat, coco.lng);
        options.title = coco.name;
        options.snippet = coco.station;
        options.icon = [UIImage imageNamed:@"mapPin"];
        [mapView_ addMarkerWithOptions:options];
    }
}

// ▼ mapViewDelegate =================================

- (void)mapView:(GMSMapView *)mapView
didChangeCameraPosition:(GMSCameraPosition *)position{
//    if(!firstLoad) return;
//    firstLoad = NO;
//    
//    CLLocationCoordinate2D homeCoordinate = [self homeLocation].coordinate;
//    [mapView_ animateToLocation:homeCoordinate];
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self hidePaper];
    currentMarker.icon = [UIImage imageNamed:@"mapPin"];
}

//- (void)mapView:(GMSMapView *)mapView
//didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
//    
//}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker{
    Coco* coco = (Coco*) marker.userData;
    [mapPaperView setModel:coco];
    [mapPaperView update];
    [self showPaper];
    if(currentMarker != nil){
        currentMarker.icon = [UIImage imageNamed:@"mapPin"];
    }
    marker.icon = [UIImage imageNamed:@"mapPinOn"];
    currentMarker = marker;
    
    return YES;
}

/**
 * Called after a marker's info window has been tapped.
 */
//- (void)mapView:(GMSMapView *)mapView
//didTapInfoWindowOfMarker:(id<GMSMarker>)marker{
//    
//}

/**
 * Called when a marker is about to become selected, and provides an optional
 * custom info window to use for that marker if this method returns a UIView.
 * If you change this view after this method is called, those changes will not
 * necessarily be reflected in the rendered version.
 *
 * The returned UIView must not have bounds greater than 500 points on either
 * dimension.  As there is only one info window shown at any time, the returned
 * view may be reused between other info windows.
 *
 * @return The custom info window for the specified marker, or nil for default
 */
//- (UIView *)mapView:(GMSMapView *)mapView
//   markerInfoWindow:(id<GMSMarker>)marker{
//    
//}

@end
