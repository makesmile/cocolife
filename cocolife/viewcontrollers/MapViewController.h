//
//  MapViewController.h
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "AbstractCocoViewController.h"
#import "CocoList.h"
#import "MapPaperView.h"

@interface MapViewController : AbstractCocoViewController<
GMSMapViewDelegate
//, CLLocationManagerDelegate
>{
    // models
    CocoList* cocoList;
    
    //views
    GMSMapView *mapView_;
    id<GMSMarker> currentMarker; //TODO だっせ
    MapPaperView* mapPaperView;
    
    // params
    BOOL firstLoad;
    CLLocationManager* locationManger;
}

-(void) assignModel:(CocoList*)cocoList_;
-(void) update;
-(CLLocation*) homeLocation;
-(void) toHome;

-(void) startLocation;
-(void) stopLocation;

@end
