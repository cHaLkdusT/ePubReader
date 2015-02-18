//
//  MasterViewController.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SectionViewController.h"
#import "PageViewController.h"

#import "AppDelegate.h"

#import "TBXML.h"
#import "Item.h"
#import "ItemRef.h"

@interface SectionViewController ()

@property NSMutableArray *sections;

@end

@implementation SectionViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (PageViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSString *containerXMLPath = [NSString stringWithFormat:@"%@/UnzippedGeography_9/META-INF/container.xml", [AppDelegate applicationDocumentsDirectory]];
    NSData *containerXMLData = [NSData dataWithContentsOfFile:containerXMLPath];
    
    NSError *error;
    TBXML *containterTBXML = [[TBXML alloc] initWithXMLData:containerXMLData error:&error];
    if (!error) {
        TBXMLElement *rootXMLElement = containterTBXML.rootXMLElement;
        TBXMLElement *rootFilesXML = [TBXML childElementNamed:@"rootfiles" parentElement:rootXMLElement];
        TBXMLElement *rootfileXML = [TBXML childElementNamed:@"rootfile" parentElement:rootFilesXML];
        NSString *contentXML = [TBXML valueOfAttributeNamed:@"full-path" forElement:rootfileXML];
        if (contentXML) {
            NSString *opfXMLPath = [NSString stringWithFormat:@"%@/UnzippedGeography_9/OEBPS/content.opf", [AppDelegate applicationDocumentsDirectory]];
            NSData *opfXMLData = [NSData dataWithContentsOfFile:opfXMLPath];
            TBXML *opfTBXML = [[TBXML alloc] initWithXMLData:opfXMLData error:&error];
            if (!error) {
                [self traverseElement:opfTBXML.rootXMLElement];
            } else {
                NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
            }
        } else {
            NSLog(@"Invalid EPUB file");
        }
    } else {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.sections[indexPath.row];
        PageViewController *controller = (PageViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.sections[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

/**
 * Stores Item and ItemRefs
 * @param element - A TBXMLElement object
 */
- (void)traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        NSString *elementStr = (NSString *) [TBXML elementName:element];
        
        if ([elementStr isEqualToString:@"item"]) {
            
        } else if ([elementStr isEqualToString:@"itemref"]){
            
        }
        
        /*
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }*/
        
        // if the element has child elements, process them
        if (element->firstChild) {
            [self traverseElement:element->firstChild];
        }
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
}

@end
