//
//  main.m
//  PPr_lab5
//
//  Created by Roman on 12/9/14.
//  Copyright (c) 2014 ininja. All rights reserved.
//

#import <Foundation/Foundation.h>


NSArray* readFile(NSString *path) {
    NSFileHandle *fileToRead = [NSFileHandle fileHandleForReadingAtPath:path];
    NSArray *line;
    if (fileToRead != nil) {
        NSString *phrase = [[NSString alloc] initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding error:nil];
        line = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    } else {
        NSLog(@"Failed to open file with data");
        return nil;
    }
    [fileToRead closeFile];
    return line;
}

NSMutableArray* searchPhrase(NSArray *whereToSearch, NSArray *whatToSearch) {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    BOOL found = NO;
    for (int i = 0; i < whatToSearch.count; ++i) {
        for (int j = 0; j < whereToSearch.count; ++j) {
            if ([[whereToSearch objectAtIndex:j] isEqualToString:[whatToSearch objectAtIndex:i]]) {
                [result addObject:[NSString stringWithFormat:@"%@ found at index %d \n", [whereToSearch objectAtIndex:j], j + 1]];
                found = YES;
            }
        }
        // if requested word was not found
        if (!found) {
            [result addObject:[NSString stringWithFormat:@"%@ not found \n", [whatToSearch objectAtIndex:i]]];
        }
        found = NO;
    }
    return result;
}

void writeToFile(NSMutableArray *resultArray, NSString *pathInWhichWrite) {
    NSFileHandle *file;
    
    file = [NSFileHandle fileHandleForUpdatingAtPath: pathInWhichWrite];
    // Write result data to file
    for (int i = 0; i < resultArray.count; ++i) {
        [file seekToEndOfFile];
        [file writeData:[[resultArray objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"DONE!");
    [file closeFile];
}

void runForrest(NSString *pathWhereRead,
                NSString *pathWithRequest,
                NSString *pathInWhichWrite){
    // Create files Handle
    NSFileHandle *fileWhereRead, *fileWithRequest, *fileInWhichWrite;
    [[NSFileManager defaultManager]createFileAtPath:pathInWhichWrite contents:nil attributes:nil];
    
    // Get file path
    fileWhereRead = [NSFileHandle fileHandleForReadingAtPath:pathWhereRead];
    fileWithRequest = [NSFileHandle fileHandleForWritingAtPath:pathWithRequest];
    fileInWhichWrite = [NSFileHandle fileHandleForWritingAtPath:pathInWhichWrite];
    
    // Check if files were created
    if (!(fileWhereRead == nil & fileWithRequest == nil & fileInWhichWrite == nil)) {
        writeToFile(searchPhrase(readFile(pathWhereRead), readFile(pathWithRequest)), pathInWhichWrite);
    } else {
        NSLog(@"Failed to open file with data to read");
    }
    
    [fileWhereRead closeFile];
    [fileWithRequest closeFile];
    [fileInWhichWrite closeFile];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        runForrest(@"/Users/roman/fileWhereRead", @"/Users/roman/fileWithRequest", @"/Users/roman/fileInWhichWrite");
    }
    return 0;
}
