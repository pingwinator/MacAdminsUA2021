//
//  ViewController.m
//  mdm
//
//  Created by Vasyl Liutikov on 16.03.21.
//

#import "ViewController.h"
#import "NSUserDefaults+DefaultValue.h"
#import "VLKeyValue.h"
@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>


@property (weak) IBOutlet NSTableView *tableview;
@property (nonatomic, strong) NSArray <VLKeyValue*> *items;
@property (nonatomic, strong) NSSet <NSString*> *allowKeys;
@property (weak) IBOutlet NSButton *fullDiskStatus;
@property (weak) IBOutlet NSButton *screenRecordingStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowKeys = [NSSet setWithArray:@[@"VLColourKey", @"VLMagicNumerKey"]];
    self.items = [NSArray array];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self readUserDefaults];
    [self checkPermissions];
}

- (void)checkPermissions
{
    if (CGPreflightScreenCaptureAccess()) {
        NSLog(@"ye");
    }
    self.screenRecordingStatus.state =  CGPreflightScreenCaptureAccess() ? NSControlStateValueOn : NSControlStateValueOff;
    self.fullDiskStatus.state = [self fullDiskAccessPermissionGranted] ? NSControlStateValueOn : NSControlStateValueOff;
}

- (BOOL)fullDiskAccessPermissionGranted {
    if (getuid() == 0) return YES;
    
    NSString *testFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Safari/Bookmarks.plist"];
    if (@available(macOS 10.15, *)) {
        testFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Safari/CloudTabs.db"];
    }
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:testFile];
    BOOL readable = [NSData dataWithContentsOfFile:testFile] != nil;
    
    return exists && readable;
}



- (void)readUserDefaults
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSDictionary<NSString *, id> *values = defaults.dictionaryRepresentation;
    NSMutableArray <VLKeyValue*> *items = [NSMutableArray array];
    for (NSString *key in values.allKeys) {
        if (![self.allowKeys containsObject:key]) {
            continue;
        }
        NSString *value = [defaults stringForKey:key];
        if (value) {
            VLKeyValue *item = [[VLKeyValue alloc] init];
            item.key = key;
            item.value = value;
            item.forced = [defaults objectIsForcedForKey:key];
            [items addObject:item];
        }
    }
    self.items = items;
    [self.tableview reloadData];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return  self.items.count;
}


- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    VLKeyValue *item = self.items[row];
    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"key"]) {
        return item.key;
    } else if ([identifier isEqualToString:@"value"]) {
        return item.value;
    } else if ([identifier isEqualToString:@"system"]) {
        return item.forced ? @"forced" : @"";
    }
    
    return [NSString stringWithFormat:@"Row: %@ , Col: %@", @(row), [tableColumn identifier]];

}

- (IBAction)readData:(id)sender {
    [self readUserDefaults];
}

- (IBAction)redButtonPressed:(id)sender {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setObject:@"red" forKey:@"VLColourKey"];
    [defaults synchronize];
    [self readUserDefaults];
}

- (IBAction)greenButtonPressed:(id)sender {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setObject:@"green" forKey:@"VLColourKey"];
    [defaults synchronize];
    [self readUserDefaults];
}

- (IBAction)askFDP:(id)sender {
    NSURL * url = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)askSRP:(id)sender {
    CGRequestScreenCaptureAccess();
}


@end
