//
//  DbHelper.m
//  cocolife
//
//  Created by yu kawase on 13/03/12.
//  Copyright (c) 2013年 cocolife. All rights reserved.
//

#import "ModelDbHelper.h"

#define DB_NAME "cocolife.db"

@implementation ModelDbHelper


static ModelDbHelper* instance;

+(ModelDbHelper*) getInstance{
    if(instance == nil){
        instance = [[ModelDbHelper alloc] init];
    }
    
    return instance;
}

-(id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    NSLog(@"initialize");
    [FMBaseDb initialize];
    [FMBaseDb create:@"cocolife.db"];
    [self createTable];
}

-(void) createTable{
    NSLog(@"createTable");
    
    NSString* createCoTableSql = @""
    "CREATE TABLE IF NOT EXISTS co ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "name TEXT,"
    "excerpt TEXT,"
    "description TEXT,"
    "hour TEXT,"
    "price TEXT,"
    "station TEXT,"
    "address TEXT,"
    "tel TEXT,"
    "url TEXT,"
    "twitter TEXT,"
    "facebook TEXT,"
    "lat REAL,"
    "lng REAL,"
    "created TEXT"
    ", image TEXT, thumb_image TEXT, favorit INT, new INTEGER DEFAULT 0)";
    
    NSString* createCoDetailTableSql = @""
    "CREATE TABLE IF NOT EXISTS  co_details ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
    "co_id int,"
    "title TEXT,"
    "image TEXT,"
    "description TEXT)";
    
    NSString* createInfoTableSql = @""
    "CREATE TABLE IF NOT EXISTS  info ("
    "id INTEGER primary key"
    ", co_id INTEGER"
    ", title TEXT"
    ", description TEXT"
    ", link TEXT"
    ", priority TEXT"
    ", created int"
    ", thumb_image TEXT"
    ", image TEXT"
    ", new INTEGER DEFAULT 0)";
    
    NSString* createFbEventsTableSql = @""
    "CREATE TABLE IF NOT EXISTS  fb_events ("
    "id TEXT primary key"
    ", co_id INT"
    ", owner TEXT"
    ", category TEXT"
    ", name TEXT"
    ", description TEXT"
    ", image TEXT"
    ", link TEXT"
    ", start_time TEXT"
    ", end_time TEXT"
    ", updated_time TEXT"
    ", location TEXT"
    ", updated TEXT"
    ", created TEXT"
    ", new INTEGER DEFAULT 0)";
    
    NSString* createNotifyTableSql = @""
    "CREATE TABLE IF NOT EXISTS  notify ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
    ", co_id INT"
    ", title TEXT"
    ", link TEXT"
    ", image TEXT"
    ", description TEXT"
    ", created INT"
    ", updated INT"
    ", readed INT INTEGER DEFAULT 0"
    ")"
    "";
    
    NSArray* createTableSqlList = [[NSArray alloc] initWithObjects:
                                   createCoTableSql, createCoDetailTableSql, createFbEventsTableSql, createInfoTableSql, createNotifyTableSql, nil];
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    for(int i=0,max=[createTableSqlList count];i<max;i++){
        NSString* sql = [createTableSqlList objectAtIndex:i];
        [db executeUpdate:sql];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
    
}

-(id) assignModels:(InfoList*)infoList_
           eventList:(EventList*)eventList_
          notifyList:(NotifyList*) notifyList_
            cocoList:(CocoList*)cocoList_
         favoritList:(CocoList*)favoritList_{
    infoList = infoList_;
    eventList = eventList_;
    notifyList = notifyList_;
    cocoList = cocoList_;
    favoritList = favoritList_;
    
    return self;
}

-(void) reloadInfoList{
    NSLog(@"reloadInfoList");
    FMDatabase* db = [FMBaseDb getDb];
    NSString* sql = [NSString stringWithFormat:@""
                     @"SELECT "
                     "   id, co_id, title, description, link, thumb_image, image , created, new, "
                     "  (SELECT name FROM co WHERE co.id = info.co_id) as shopName "
                     "FROM "
                     "   info "
                     "ORDER BY "
                     "   created DESC "
                     "LIMIT 20 "
                     ""];
    [FMBaseDb open];
    FMResultSet* results = [db executeQuery:sql];
    [FMBaseDb showError];
    [infoList clear];
    while([results next]){
        Info* info = [[Info alloc] initWithResultSet:results];
        [infoList add:info];
    }
    [FMBaseDb close];
}

-(void) reloadEventList{
    NSTimeInterval addDay = -9*60*60;
    NSString* now = [Utils dateToString:[NSDate dateWithTimeInterval:addDay sinceDate:[NSDate date]] format:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString* query = @""
    "SELECT "
    "    id, co_id, owner, category, name, description, image, link, start_time, end_time, updated_time, location, updated, created, new "
    "    ,(SELECT address FROM co WHERE co.id = fb_events.co_id) AS address "
    "    ,(SELECT station FROM co WHERE co.id = fb_events.co_id) AS station "
    "FROM "
    "    fb_events "
    "WHERE "
    "    end_time > ? "
    "ORDER BY "
    "    start_time ASC "
    "";
    [eventList clear];
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    FMResultSet* resultSet = [db executeQuery:query, now];
    while([resultSet next]){
        Event* event = [[Event alloc] initWithResultSet:resultSet];
        [eventList add:event];
    }
    [FMBaseDb close];
}

-(void) reloadNotifyList{
    [notifyList clear];
    
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    
    NSString* sql = @"SELECT notify.*, co.name AS shopName FROM notify INNER JOIN co ON notify.co_id = co.id ORDER BY created DESC";
    FMResultSet* resultSet = [db executeQuery:sql];
    while([resultSet next]){
        Notify* notify = [[Notify alloc] initWithResultSet:resultSet];
        [notifyList add:notify];
    }
    
    [FMBaseDb close];
}

-(void) reloadCocoList{
    NSString* query = [NSString stringWithFormat:@""
                       "select "
                       "    id, name, excerpt, description, hour, price, "
                       "    station, address, tel, url, twitter, facebook, "
                       "    lat, lng, created, image, thumb_image, favorit, new "
                       "from "
                       "    co "
                       "ORDER BY "
                       "    new DESC, created DESC "
                       ""];
    [cocoList clear];
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    FMResultSet* resultSet = [db executeQuery:query];
    while([resultSet next]){
        Coco* coco = [[Coco alloc] initWithResultSet:resultSet];
        [cocoList add:coco];
    }
    [self mergeDetailList:cocoList];
    
    [FMBaseDb close];
}

-(void) mergeDetailList:(CocoList*)cocoList_{
    for(int i=0,max=[cocoList_ count];i<max;i++){
        Coco* coco = [cocoList_ get:i];
        [self mergeDetailListRow:coco];
    }
}

-(void) mergeDetailListRow:(Coco*)coco{
    NSString* query = @""
    "select "
    "    id, title, description, image "
    "from "
    "    co_details "
    "WHERE "
    "    co_id = ? "
    "ORDER BY "
    "    id ASC "
    "";
    
    FMDatabase* db = [FMBaseDb getDb];
    FMResultSet* resultSet = [db executeQuery:query, [NSNumber numberWithInt:coco.id_]];
    NSMutableArray* detailList = [[NSMutableArray alloc] init];
    while([resultSet next]){
        CocoDetail* cocoDetail = [[CocoDetail alloc] initWithResultSet:resultSet];
        [detailList addObject:cocoDetail];
    }
    [coco setDetailList:detailList];
    
}

-(void) reloadFavoritList{
    NSString* query = [NSString stringWithFormat:@""
                       "select "
                       "    id, name, excerpt, description, hour, price, "
                       "    station, address, tel, url, twitter, facebook, "
                       "    lat, lng, created, image, thumb_image, favorit, new "
                       "from "
                       "    co "
                       " WHERE favorit = 1 "
                       "ORDER BY "
                       "    created DESC "
                       ""];
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    FMResultSet* resultSet = [db executeQuery:query];
    [FMBaseDb showError];
    [favoritList clear];
    while([resultSet next]){
        Coco* coco = [[Coco alloc] initWithResultSet:resultSet];
        [favoritList add:coco];
    }
    [FMBaseDb close];
}

-(Coco*) createCocoModel:(int)cocoId{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    NSString* sql = [NSString stringWithFormat:@""
                     "select "
                     "    id, name, excerpt, description, hour, price, "
                     "    station, address, tel, url, twitter, facebook, "
                     "    lat, lng, created, image, thumb_image, favorit, new "
                     "from "
                     "    co "
                     "WHERE id = %d"
                     "", cocoId];
    FMResultSet* resultSet = [db executeQuery:sql];
    [resultSet next];
    Coco* coco = [[Coco alloc] initWithResultSet:resultSet];
    
    [FMBaseDb close];
    return coco;
}

-(void) updateData:(NSDictionary*) jsonDic{
    NSDictionary* coData = [jsonDic objectForKey:@"coData"];
    // co
    NSArray* createdCo = [coData objectForKey:@"created"];
    [self insertCoList:createdCo];
    NSArray* updatedCo = [coData objectForKey:@"updated"];
    [self updateCoList:updatedCo];
    NSArray* deletedCo = [coData objectForKey:@"deleted"];
    [self deleteCoList:deletedCo];
    
    // info
    NSDictionary* infoData = [jsonDic objectForKey:@"infoData"];
    NSArray* createdInfo = [infoData objectForKey:@"created"];
    [self insertInfoList:createdInfo];
    NSArray* updatedInfo = [infoData objectForKey:@"updated"];
    [self updateInfoList:updatedInfo];
    NSArray* deletedInfo = [infoData objectForKey:@"deleted"];
    [self deleteCoList:deletedInfo];
    
    // events
    NSDictionary* eventData = [jsonDic objectForKey:@"fbEventData"];
    NSArray* createdEvent = [eventData objectForKey:@"created"];
    [self insertEventList:createdEvent];
    NSArray* updatedEvent = [eventData objectForKey:@"updated"];
    [self updateEventList:updatedEvent];
    NSArray* deletedEvent = [eventData objectForKey:@"deleted"];
    [self deleteEventList:deletedEvent];
    
    // 通知
    NSDictionary* notifyData = [jsonDic objectForKey:@"notifyData"];
    NSArray* createdNotify = [notifyData objectForKey:@"created"];
    [self insertNotifyList:createdNotify];
    NSArray* updatedNotify = [notifyData objectForKey:@"updated"];
    [self updateNotifyList:updatedNotify];
    NSArray* deletedNotify = [notifyData objectForKey:@"deleted"];
    [self deleteNotifyList:deletedNotify];
}

-(void) insertCoList:(NSArray*)created{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSMutableArray* allItems = [[NSMutableArray alloc] init];
    
    // coテーブル ====================
    NSString* sql = @""
    "INSERT OR IGNORE INTO co "
    "  ("
    "   id, name, excerpt, description, hour, price, "
    "   station, address, tel, url, twitter, facebook, "
    "   lat, lng, created, image, thumb_image, new "
    "  )"
    "VALUES "
    "  (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    for(int i=0,max=[created count];i<max;i++){
        NSDictionary* row = [created objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"id"]
         , [row objectForKey:@"name"]
         , [row objectForKey:@"excerpt"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"hour"]
         , [row objectForKey:@"price"]
         , [row objectForKey:@"station"]
         , [row objectForKey:@"address"]
         , [row objectForKey:@"tel"]
         , [row objectForKey:@"url"]
         , [row objectForKey:@"twitter"]
         , [row objectForKey:@"facebook"]
         , [row objectForKey:@"lat"]
         , [row objectForKey:@"lng"]
         , [row objectForKey:@"created"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"thumb_image"]
         , [row objectForKey:@"new"]
         ];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
        
        NSArray* details = [row objectForKey:@"details"];
        for(int j=0,jMax=[details count];j<jMax;j++){
            [allItems addObject:[details objectAtIndex:j]];
        }
    }
    
    // co_details テーブル===========================
    sql = @""
    "INSERT OR IGNORE INTO co_details "
    "  ("
    "   id, co_id, title, image, description "
    "  )"
    "VALUES "
    "  (?, ?, ?, ?, ?)";
    for(int i=0,max=[allItems count];i<max;i++){
        NSDictionary* row = [allItems objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"id"]
         , [row objectForKey:@"co_id"]
         , [row objectForKey:@"title"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"description"]
         ];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
    
}

-(void) updateCoList:(NSArray*)updated{
    // 詳細用
    NSMutableArray* detailList = [[NSMutableArray alloc] init];
    
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    
    // coテーブル =====================
    NSString* sql = @""
    "UPDATE co SET "
    "   name = ?, excerpt = ?, description = ?, hour = ?, "
    "   price = ?, station = ?, address = ?, tel = ?, "
    "   url = ?, twitter = ?, facebook = ?, lat = ?, "
    "   lng = ?, created = ?, image = ?, thumb_image= ? , new = ? "
    "WHERE "
    "   id = ?"
    "";
    for(int i=0,max=[updated count];i<max;i++){
        NSDictionary* row = [updated objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"name"]
         , [row objectForKey:@"excerpt"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"hour"]
         , [row objectForKey:@"price"]
         , [row objectForKey:@"station"]
         , [row objectForKey:@"address"]
         , [row objectForKey:@"tel"]
         , [row objectForKey:@"url"]
         , [row objectForKey:@"twitter"]
         , [row objectForKey:@"facebook"]
         , [row objectForKey:@"lat"]
         , [row objectForKey:@"lng"]
         , [row objectForKey:@"created"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"thumb_image"]
         , [row objectForKey:@"new"]
         , [row objectForKey:@"id"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
        
        NSArray* details = [row objectForKey:@"details"];
        for(int j=0,jMax=[details count];j<jMax;j++){
            [detailList addObject:[details objectAtIndex:j]];
        }
    }
    
    // co_detail テーブル ============================
    sql = @""
    "UPDATE co_details SET "
    "   title = ?, image = ?, description = ? "
    "WHERE "
    "   id = ?"
    "";
    for(int i=0,max=[detailList count];i<max;i++){
        NSDictionary* row = [detailList objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"title"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"id"]
         ];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) deleteCoList:(NSArray*)deleted{
    
    for(int i=0,max=[deleted count];i<max;i++){
        NSDictionary* row = [deleted objectAtIndex:i];
        [self deleteCo:[row objectForKey:@"id"]];
    }
    
}

-(void) deleteCo:(NSNumber*) coId{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    
    // coテーブル
    [db executeUpdate:@"DELETE FROM co WHERE id = ?", coId];
    if([FMBaseDb hasError]){
        [FMBaseDb showError];
        [FMBaseDb rollback];
        [FMBaseDb close];
        return;
    }
    
    // co_detailテーブル
    [db executeUpdate:@"DELETE FROM co_details WHERE co_id = ?", coId];
    if([FMBaseDb hasError]){
        [FMBaseDb showError];
        [FMBaseDb rollback];
        [FMBaseDb close];
        return;
    }
    
    // infoテーブル
    [db executeUpdate:@"DELETE FROM info WHERE co_id = ?", coId];
    if([FMBaseDb hasError]){
        [FMBaseDb showError];
        [FMBaseDb rollback];
        [FMBaseDb close];
        return;
    }
    
    // fbEventsテーブル
    [db executeUpdate:@"DELETE FROM fb_events WHERE co_id = ?", coId];
    if([FMBaseDb hasError]){
        [FMBaseDb showError];
        [FMBaseDb rollback];
        [FMBaseDb close];
        return;
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) insertEventList:(NSArray*)created{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString*
    sql = [NSString stringWithFormat:@""
           "INSERT OR IGNORE INTO fb_events "
           "  (id, co_id, owner, category, name, description, image, link, start_time, end_time, updated_time, location, updated, created, new) "
           "VALUES "
           "  (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
           ];
    for(int i=0,max=[created count];i<max;i++){
        NSDictionary* row = [created objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"id"]
         , [row objectForKey:@"co_id"]
         , [row objectForKey:@"owner"]
         , [row objectForKey:@"category"]
         , [row objectForKey:@"name"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"link"]
         , [row objectForKey:@"start_time"]
         , [row objectForKey:@"end_time"]
         , [row objectForKey:@"updated_time"]
         , [row objectForKey:@"location"]
         , [row objectForKey:@"updated"]
         , [row objectForKey:@"created"]
         , [row objectForKey:@"new"]
         ];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) updateEventList:(NSArray*)updated{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    
    NSString* sql;
    sql = [NSString stringWithFormat:@""
           "UPDATE fb_events SET "
           "    owner = ?, category = ?, name = ?, description = ?, image = ?, link = ?, start_time = ?, "
           "    end_time = ?, updated_time = ?, location = ?, updated = ?, new = ? "
           "WHERE "
           "  id = ?"
           ];
    for(int i=0,max=[updated count];i<max;i++){
        NSDictionary* row = [updated objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"owner"]
         , [row objectForKey:@"category"]
         , [row objectForKey:@"name"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"link"]
         , [row objectForKey:@"start_time"]
         , [row objectForKey:@"end_time"]
         , [row objectForKey:@"updated_time"]
         , [row objectForKey:@"location"]
         , [row objectForKey:@"updated"]
         , [row objectForKey:@"new"]
         , [row objectForKey:@"id"]
         ];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

// Fbイベント削除
-(void) deleteEventList:(NSArray*)deleted{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    
    for(int i=0,max=[deleted count];i<max;i++){
        NSDictionary* row = [deleted objectAtIndex:i];
        [db executeUpdate:@"DELETE FROM fb_events WHERE id = ?", [row objectForKey:@"id"]];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) insertInfoList:(NSArray*)created{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString*
    sql = [NSString stringWithFormat:@""
           "INSERT OR IGNORE INTO info "
           "  (id, co_id, title, description, image, thumb_image, link, created, new) "
           "VALUES "
           "  (?, ?, ?, ?, ?, ?, ?, ?, ?)"
           ];
    for(int i=0,max=[created count];i<max;i++){
        NSDictionary* row = [created objectAtIndex:i];
        [db executeUpdate:sql
         ,[row objectForKey:@"id"]
         ,[row objectForKey:@"co_id"]
         ,[row objectForKey:@"title"]
         ,[row objectForKey:@"description"]
         ,[row objectForKey:@"image"]
         ,[row objectForKey:@"thumb_image"]
         ,[row objectForKey:@"link"]
         ,[row objectForKey:@"created"]
         ,[row objectForKey:@"new"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) updateInfoList:(NSArray*)updated{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString*
    sql = [NSString stringWithFormat:@""
           "UPDATE info SET "
           "  co_id = ?, title = ?, description = ?, image = ?, thumb_image = ?, link = ?, created = ?, new = ? "
           "WHERE "
           "  id = ?"
           ];
    for(int i=0,max=[updated count];i<max;i++){
        NSDictionary* row = [updated objectAtIndex:i];
        [db executeUpdate:sql
         , [row objectForKey:@"co_id"]
         , [row objectForKey:@"title"]
         , [row objectForKey:@"description"]
         , [row objectForKey:@"image"]
         , [row objectForKey:@"thumb_image"]
         , [row objectForKey:@"link"]
         , [row objectForKey:@"created"]
         , [row objectForKey:@"new"]
         , [row objectForKey:@"id"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
    
}

-(void) deleteInfoList:(NSArray*)deleted{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    
    
    for(int i=0,max=[deleted count];i<max;i++){
        NSDictionary* row = [deleted objectAtIndex:i];
        [db executeUpdate:@"DELETE FROM info WHERE id = ?", [row objectForKey:@"id"]];
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
    
}

// ▼ 通知 ========================================

-(void) insertNotifyList:(NSArray*) created{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString* sql = @"INSERT OR IGNORE INTO notify "
    "   (id, co_id, title, link, image, description, created) "
    " VALUES "
    "   (?, ?, ?, ?, ?, ?, ?)";
    for(int i=0,max=[created count];i<max;i++){
        NSDictionary* row = [created objectAtIndex:i];
        [db executeUpdate:sql
         ,[row objectForKey:@"id"]
         ,[row objectForKey:@"co_id"]
         ,[row objectForKey:@"title"]
         ,[row objectForKey:@"link"]
         ,[row objectForKey:@"image"]
         ,[row objectForKey:@"description"]
         ,[row objectForKey:@"created"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
        
        NSLog(@"insert:%@", [row objectForKey:@"title"]);
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) updateNotifyList:(NSArray*) updated{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString* sql = @"UPDATE notify SET "
    "title = ?, link = ?, image, description = ?, updated = ? "
    "WHERE id = ?"
    "";
    for(int i=0,max=[updated count];i<max;i++){
        NSDictionary* row = [updated objectAtIndex:i];
        [db executeUpdate:sql
         ,[row objectForKey:@"title"]
         ,[row objectForKey:@"link"]
         ,[row objectForKey:@"image"]
         ,[row objectForKey:@"description"]
         ,[row objectForKey:@"updated"]
         ,[row objectForKey:@"id"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
        
        NSLog(@"update:%@", [row objectForKey:@"title"]);
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) deleteNotifyList:(NSArray*) deleted{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    [FMBaseDb beginTransaction];
    NSString* sql = @"DELETE FROM notify WHERE id = ?";
    for(int i=0,max=[deleted count];i<max;i++){
        NSDictionary* row = [deleted objectAtIndex:i];
        [db executeUpdate:sql
         ,[row objectForKey:@"id"]
         ];
        
        if([FMBaseDb hasError]){
            [FMBaseDb showError];
            [FMBaseDb rollback];
            [FMBaseDb close];
            return;
        }
        
        NSLog(@"delete:%@", [row objectForKey:@"title"]);
    }
    
    [FMBaseDb commit];
    [FMBaseDb close];
}

-(void) favorit:(Coco*)coco{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    NSString* sql = @"UPDATE co SET favorit = 1 WHERE id = ?";
    [db executeUpdate:sql, [NSNumber numberWithInt:coco.id_]];
    [FMBaseDb showError];
    [FMBaseDb close];
}

-(void) unFavorit:(Coco*)coco{
    FMDatabase* db = [FMBaseDb getDb];
    [FMBaseDb open];
    NSString* sql = @"UPDATE co SET favorit = 0 WHERE id = ?";
    [db executeUpdate:sql, [NSNumber numberWithInt:coco.id_]];
    [FMBaseDb showError];
    [FMBaseDb close];
}


@end