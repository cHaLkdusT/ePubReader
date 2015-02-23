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
@property NSMutableArray *arrItemRefs;
@property NSMutableDictionary *items;
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
    
    _arrItemRefs = [NSMutableArray array];
    _items = [NSMutableDictionary dictionary];
    
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
        PageViewController *controller = (PageViewController *)[[segue destinationViewController] topViewController];
        
        controller.items = _items;
        controller.arrItemRefs = _arrItemRefs;
        controller.tableViewCellRow = [self.tableView indexPathForSelectedRow].row;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        // Hide MasterView once user have selected a cell
        UIBarButtonItem *barButtonItem = [self.splitViewController displayModeButtonItem];
        [[UIApplication sharedApplication] sendAction:barButtonItem.action to:barButtonItem.target from:nil forEvent:nil];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrItemRefs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ItemRef *itemRef = self.arrItemRefs[indexPath.row];
    cell.textLabel.text = itemRef.idRef;
    return cell;
}

/**
 * Stores Item and ItemRefs
 * @param element - A TBXMLElement object
 */
- (void)traverseElement:(TBXMLElement *)element {
    do {
        NSLog(@"%@",[TBXML elementName:element]); // Display the name of the element
        
        NSString *elementStr = (NSString *) [TBXML elementName:element];
        if ([elementStr isEqualToString:@"item"]) {
            Item *item = [[Item alloc] initWithTBXMLElement:element];
            [_items setObject:item forKey:item.ID];
            
        } else if ([elementStr isEqualToString:@"itemref"]){
            ItemRef *itemRef = [[ItemRef alloc] initWithTBXMLElement:element];
            [_arrItemRefs addObject:itemRef];
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
