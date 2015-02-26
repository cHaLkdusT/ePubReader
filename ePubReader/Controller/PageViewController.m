//
//  DetailViewController.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "PageViewController.h"
#import "AppDelegate.h"
#import "Section.h"

@interface PageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *pageViews;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property long currentPageDisplayed;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page isCurrent:(BOOL)isCurrent;
- (void)purgePage:(NSInteger)page;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger pageCount = _arrSections.count;
    
    // Removed PageControl for now from StoryBoard
    _pageControl.currentPage = _tableViewCellRow;
    _pageControl.numberOfPages = pageCount;
    
    _pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [_pageViews addObject:[NSNull null]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeScrollView];
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (void)initializeScrollView
{
    CGSize pagesScrollViewSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * _arrSections.count, pagesScrollViewSize.height);
    _scrollView.contentOffset = [self offsetForPageAtIndex:_scrollView row:_tableViewCellRow];
    _scrollView.delegate = self;
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    NSInteger page = [self getCurrentPage:_scrollView];
    _currentPageDisplayed = page+1;
    
    // Update the page control
    _pageControl.currentPage = _tableViewCellRow;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    int count = 0; // counter to determine what webView to put the tag in
    for (NSInteger i = firstPage; i <= lastPage; i++) {
        [self loadPage:i isCurrent:count++ == 1];
    }
    
    // Purge anything after the last page
    for (NSInteger i = lastPage+1; i < _arrSections.count; i++) {
        [self purgePage:i];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= _arrSections.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [_pageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [_pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadPage:(NSInteger)page isCurrent:(BOOL)isCurrent {
    if (page < 0 || page >= _arrSections.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    UIView *pageView = [_pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null]) {
        CGRect frame = _scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        NSString *path = [NSString stringWithFormat:@"%@/UnzippedGeography_9/OEBPS/%@", [AppDelegate applicationDocumentsDirectory], [self fileToLoad:page]];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
        webView.paginationMode = UIWebPaginationModeLeftToRight;
        webView.scrollView.directionalLockEnabled = YES;
        webView.scrollView.pagingEnabled = YES;
        webView.tag = page+1;
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        [_scrollView addSubview:webView];

        [self.pageViews replaceObjectAtIndex:page withObject:webView];
    }
}

- (CGPoint)offsetForPageAtIndex:(UIScrollView *)scrollView row:(NSInteger)index {
    CGPoint offset;
    offset.x = (scrollView.frame.size.width * index);
    offset.y = 0;
    return offset;
}

- (NSString *)fileToLoad:(NSInteger)page
{
    Section *section = _arrSections[page];
    NSString *file;
    
    NSRange range = [section.src rangeOfString:@"#"];
    if (range.location != NSNotFound) {
        file = [section.src substringWithRange:NSMakeRange(0, range.location)];
    } else {
        file = section.src;
    }
    return file;
}

- (NSInteger)getCurrentPage:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    return (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
}

//#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisiblePages];
}

#pragma mark - IBActions

- (IBAction)prevButton:(id)sender {
    UIWebView *webView = (UIWebView *)[_scrollView viewWithTag:_currentPageDisplayed];
    NSInteger page = [self getCurrentPage:webView.scrollView];
    if (page > 0) {
        [webView.scrollView setContentOffset:[self offsetForPageAtIndex:webView.scrollView row:page-1] animated:YES];
    } else {
        [_scrollView setContentOffset:[self offsetForPageAtIndex:_scrollView row:--_tableViewCellRow] animated:YES];
    }
}

- (IBAction)nextButton:(id)sender {
    UIWebView *webView = (UIWebView *)[_scrollView viewWithTag:_currentPageDisplayed];
    NSInteger page = [self getCurrentPage:webView.scrollView];
    if (page < webView.pageCount-1) {
        [webView.scrollView setContentOffset:[self offsetForPageAtIndex:webView.scrollView row:page+1] animated:YES];
    } else {
        [_scrollView setContentOffset:[self offsetForPageAtIndex:_scrollView row:++_tableViewCellRow] animated:YES];
    }
}
@end
