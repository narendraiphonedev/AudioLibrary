//
//  RecordListTableViewController.m
//  AudioLibrary
//
//  Created by Admin on 27/11/15.
//  Copyright (c) 2015 itsculptors. All rights reserved.
//

#import "RecordListTableViewController.h"
#import "DatabaseManager.h"
#import "AudioRecord.h"
#import "IQAudioRecorderController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RecordListTableViewController ()<IQAudioRecorderControllerDelegate,UITableViewDataSource,UITableViewDelegate> {
    FMResultSet *rs;
    NSMutableArray *recordsArray;
    NSString *audioFilePath;
    NSUInteger totalRecords;
    
}
@property (nonatomic, strong) IBOutlet UITableView *audioTableView;
@end

@implementation RecordListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readRecrodsFromDB];
}

#pragma mark - Database Methods
-(void)readRecrodsFromDB {
    [[[DatabaseManager sharedDatabaseManager] database] open];
    
    rs = [[[DatabaseManager sharedDatabaseManager] database] executeQuery:@"select * from audioFiles"];
    recordsArray = [NSMutableArray new];
    while ([rs next]) {
        AudioRecord *record = [AudioRecord new];
        record.filename = [rs stringForColumn:@"filename"];
        record.path     = [rs stringForColumn:@"path"];
        
        [recordsArray addObject:record];
    }
    totalRecords = recordsArray.count;
    [[[DatabaseManager sharedDatabaseManager] database] close];
}
-(void)insertRecords:(AudioRecord *)newRecord {
    [[[DatabaseManager sharedDatabaseManager] database] open];
    
    NSString *insertQuery = [NSString stringWithFormat:@"insert into audioFiles values ('%@','%@')",newRecord.filename,newRecord.path
                             ];
    
    [[[DatabaseManager sharedDatabaseManager] database] executeUpdate:insertQuery];
    
    [[[DatabaseManager sharedDatabaseManager] database] close];
    [self readRecrodsFromDB];
    [self.audioTableView reloadData];
    
}
- (IBAction)newRecordButtonAction:(UIBarButtonItem *)sender {
    IQAudioRecorderController *recordingController = [[IQAudioRecorderController alloc] init];
    recordingController.delegate = self;
    [self presentViewController:recordingController animated:YES completion:nil];

}

#pragma mark - IQAudioRecorderControllerDelegate
-(void)audioRecorderController:(IQAudioRecorderController*)controller didFinishWithAudioAtPath:(NSString*)filePath {
    
    audioFilePath = filePath;
    NSString *filename = [NSString stringWithFormat:@"Voice%ld",totalRecords+1];
    AudioRecord *newRecord = [AudioRecord new];
    newRecord.filename =   filename;
    newRecord.path     =   filePath;
    [self insertRecords:newRecord];
}

-(void)audioRecorderControllerDidCancel:(IQAudioRecorderController*)controller {
    
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return recordsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    AudioRecord *record  = (AudioRecord *)[recordsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = record.filename;
    
    return cell;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioRecord *playRecord = (AudioRecord *)[recordsArray objectAtIndex:indexPath.row];
    
    MPMoviePlayerViewController *playController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:playRecord.path]];
    
    [self presentMoviePlayerViewControllerAnimated:playController];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
