//
//  SectionTableViewController.m
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SectionTableViewController.h"
#import "SectionTableViewCell.h"
#import "PageViewController.h"
#import "GDataXMLNode.h"
#import "SectionItem.h"
#import "AppDelegate.h"
#import "Section.h"

@interface SectionTableViewController () {
    NSDictionary *NameSpace;
}

@property (nonatomic, strong) NSMutableArray *arrSectionContainer;
@property (nonatomic, strong) NSMutableArray *selectedTreeItems;
@property (nonatomic, strong) NSDictionary *dicPathContainers;
@property (nonatomic, strong) NSMutableArray *treeItems;
@property (nonatomic, strong) NSArray *arrSectionItems;
@end

@implementation SectionTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NameSpace = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.daisy.org/z3986/2005/ncx/", @"epub", nil];
    
    _dicPathContainers = [NSMutableDictionary dictionary];
    _arrSectionContainer = [NSMutableArray array];
    _selectedTreeItems = [NSMutableArray array];
    _treeItems = [self listItemsAtPath:@"/"];
    
    [[self.tableView delegate] tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [self.tableView setRowHeight:50.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.tableView delegate] tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_treeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SectionItem *treeItem = [self.treeItems objectAtIndex:indexPath.row];
    [cell.titleTextField setUserInteractionEnabled:NO];
    [cell.titleTextField setText:[treeItem base]];
    [cell setTreeItem:treeItem];
    
    [cell layoutIfNeeded];
    [cell.titleTextField setFrame:CGRectMake(cell.iconButton.frame.origin.x, 0,
                                             cell.frame.size.width - cell.titleTextField.frame.origin.x,
                                             cell.frame.size.height)];
    
    [cell setSelectionStyle:[treeItem numberOfSubitems] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault];
    [cell setLevel:[treeItem submersionLevel]];
    return cell;
}

- (void)selectingItemsToDelete:(SectionItem *)selItems saveToArray:(NSMutableArray *)deleteSelectingItems{
    for (SectionItem *obj in selItems.ancestorSelectingItems) {
        [self selectingItemsToDelete:obj saveToArray:deleteSelectingItems];
    }
    
    [deleteSelectingItems addObject:selItems];
}

- (NSMutableArray *)removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SectionTableViewCell *cell = (SectionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        for (SectionItem *tmpTreeItem in treeItemsToRemove) {
            if ([cell.treeItem isEqualToSelectingItem:tmpTreeItem])
                [result addObject:indexPath];
        }
    }
    
    return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        PageViewController *controller = (PageViewController *)[[segue destinationViewController] topViewController];

        NSLog(@"%li", [self.tableView indexPathForSelectedRow].row);
        controller.arrSections = _arrSectionContainer;
        controller.tableViewCellRow = [self.tableView indexPathForSelectedRow].row;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        // Hide MasterView once user have selected a cell
//        UIBarButtonItem *barButtonItem = [self.splitViewController displayModeButtonItem];
//        [[UIApplication sharedApplication] sendAction:barButtonItem.action to:barButtonItem.target from:nil forEvent:nil];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = (SectionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    NSInteger insertTreeItemIndex = [self.treeItems indexOfObject:cell.treeItem];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSMutableArray *insertselectingItems = [self listItemsAtPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
    
    NSMutableArray *removeIndexPaths = [NSMutableArray array];
    NSMutableArray *treeItemsToRemove = [NSMutableArray array];
    
    for (SectionItem *tmpTreeItem in insertselectingItems) {
        [tmpTreeItem setPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
        [tmpTreeItem setParentSelectingItem:cell.treeItem];
        
        [cell.treeItem.ancestorSelectingItems removeAllObjects];
        [cell.treeItem.ancestorSelectingItems addObjectsFromArray:insertselectingItems];
        
        insertTreeItemIndex++;
        
        BOOL contains = NO;
        for (SectionItem *tmp2TreeItem in self.treeItems) {
            if ([tmp2TreeItem isEqualToSelectingItem:tmpTreeItem]) {
                contains = YES;
                
                [self selectingItemsToDelete:tmp2TreeItem saveToArray:treeItemsToRemove];
                removeIndexPaths = [self removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove];
            }
        }
        
        for (SectionItem *tmp2TreeItem in treeItemsToRemove) {
            [self.treeItems removeObject:tmp2TreeItem];
            
            for (SectionItem *tmp3TreeItem in self.selectedTreeItems) {
                if ([tmp3TreeItem isEqualToSelectingItem:tmp2TreeItem]) {
                    [self.selectedTreeItems removeObject:tmp2TreeItem];
                    break;
                }
            }
        }
        
        if (!contains) {
            [tmpTreeItem setSubmersionLevel:tmpTreeItem.submersionLevel];
            [self.treeItems insertObject:tmpTreeItem atIndex:insertTreeItemIndex];
            
            NSIndexPath *indexPth = [NSIndexPath indexPathForRow:insertTreeItemIndex inSection:0];
            [insertIndexPaths addObject:indexPth];
        }
    }
    
    if ([insertIndexPaths count]) {
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if ([removeIndexPaths count]) {
        [self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - Helper methods
- (NSMutableArray *)listItemsAtPath:(NSString *)path
{
    if (self.arrSectionItems == nil) {
        NSMutableDictionary *dicPathContainers = [[NSMutableDictionary alloc] init];
        NSMutableArray *arrCourseItems = [[NSMutableArray alloc] init];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/UnzippedGeography_9/OEBPS/toc.ncx", [AppDelegate applicationDocumentsDirectory]];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
        if (doc == nil) {
            return nil;
            
        } else {
            NSArray *arrSections = [self getNavPoints:[doc nodesForXPath:@"//epub:ncx/epub:navMap/epub:navPoint" namespaces:NameSpace error:nil] level:0];
            for (Section *section in arrSections) {
                SectionItem *sectionItem = [[SectionItem alloc] init];
                [sectionItem setPath:@"/"];
                [sectionItem setBase:section.text];
                [sectionItem setParentSelectingItem:nil];
                [sectionItem setSubmersionLevel:section.level];
                [sectionItem setNumberOfSubitems:section.arrNavPoints.count];
                [sectionItem setAncestorSelectingItems:[NSMutableArray array]];
                [sectionItem setAncestorSelectingItems:[section.arrNavPoints count] > 0 ? [self test:section parentSectionItem:sectionItem dictionaryContainers:dicPathContainers] : [NSMutableArray array]];
                
                [arrCourseItems addObject:sectionItem];
            }
        }
        
        self.arrSectionItems = arrCourseItems;
        self.dicPathContainers = dicPathContainers;
    }
    
    
    if ([@"/" isEqualToString:path]) {
        return [self.arrSectionItems mutableCopy];
    } else if ([self.dicPathContainers objectForKey:path] != nil) {
        return [[self.dicPathContainers objectForKey:path] mutableCopy];
    } else {
        return [NSMutableArray array];
    }
}

- (void)saveArrayToDictionaryByCourseItemPath:(NSArray *)array dictionary:(NSMutableDictionary *)dictionary
{
    if (array.count > 0) {
        SectionItem *sectionItem = array[0];
        [dictionary setObject:[NSArray arrayWithArray:array] forKey:sectionItem.path];
    }
}


#pragma mark - Utility (Will return sorted:ASC array based on text displayed)
- (NSArray *)convertNSSetToNSArray:(NSSet *)set sortBy:(NSString *)sortBy
{
    NSArray *array = [[NSArray alloc] init];
    if (set != nil && set.count > 0) {
        NSArray *arrDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortBy ascending:YES]];
        array = [[set allObjects] sortedArrayUsingDescriptors:arrDescriptors];
    }
    
    return array;
}

- (NSArray *)getNavPoints:(NSArray *)arrSource level:(int)level
{
    NSMutableArray *arrNavPoints = [NSMutableArray array];
    for (GDataXMLElement *navPoint in arrSource) {
        NSString *text = [[[navPoint nodesForXPath:@"./epub:navLabel/epub:text" namespaces:NameSpace error:nil] objectAtIndex:0] stringValue];
        NSString *filePath = [NSString stringWithFormat:@"%@", [[[navPoint elementsForName:@"content"][0] attributeForName:@"src"] stringValue]];

        Section *section = [Section new];
        section.src = filePath;
        section.level = level;
        section.text = text;

        [_arrSectionContainer addObject:section];
        
        NSArray *arrChildNavPoints = [navPoint elementsForName:@"navPoint"];
        if (arrChildNavPoints != nil) {
            section.arrNavPoints = [self getNavPoints:arrChildNavPoints level:level+1];
        }
        
        [arrNavPoints addObject:section];
    }
    return arrNavPoints;
}

- (NSMutableArray *)test:(Section *)parentSection parentSectionItem:(SectionItem *)parentSectionItem dictionaryContainers:(NSMutableDictionary *)dicPathContainers
{
    NSMutableArray *arr = [NSMutableArray array];
    for (Section *section in parentSection.arrNavPoints) {
        SectionItem *currentSectionItem = [[SectionItem alloc] init];
        [currentSectionItem setPath:[self getPath:section currentSectionItem:parentSectionItem parentPath:parentSectionItem.path]];
        [currentSectionItem setNumberOfSubitems:section.arrNavPoints.count];
        [currentSectionItem setParentSelectingItem:parentSectionItem];
        [currentSectionItem setSubmersionLevel:section.level];
        [currentSectionItem setBase:section.text];
        [currentSectionItem setAncestorSelectingItems:[section.arrNavPoints count] > 0 ? [self test:section parentSectionItem:currentSectionItem dictionaryContainers:dicPathContainers] : [NSMutableArray array]];

        [arr addObject:currentSectionItem];
    }
    [self saveArrayToDictionaryByCourseItemPath:arr dictionary:dicPathContainers];
    return arr;
}

- (NSString *)getPath:(Section *)currentSection currentSectionItem:(SectionItem *)currentSectionItem parentPath:(NSString *)parentPath
{
    NSString *path = [NSString stringWithFormat:@"/%@", currentSectionItem.base];
    for (int i = 1; i < currentSection.level; i++) {
        path = [NSString stringWithFormat:@"%@/%@", parentPath, currentSectionItem.base];
    }
    return path;
}
@end
