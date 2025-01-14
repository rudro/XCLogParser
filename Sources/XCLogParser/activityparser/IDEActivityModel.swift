// Copyright (c) 2019 Spotify AB.
//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import Foundation

public struct IDEActivityLog: Encodable {
    public let version: Int8
    public let mainSection: IDEActivityLogSection
}

public class IDEActivityLogSection: Encodable {
    public let sectionType: Int8
    public let domainType: String
    public let title: String
    public let signature: String
    public let timeStartedRecording: Double
    public let timeStoppedRecording: Double
    public let subSections: [IDEActivityLogSection]
    public let text: String
    public let messages: [IDEActivityLogMessage]
    public let wasCancelled: Bool
    public let isQuiet: Bool
    public let wasFetchedFromCache: Bool
    public let subtitle: String
    public let location: DVTDocumentLocation
    public let commandDetailDesc: String
    public let uniqueIdentifier: String
    public let localizedResultString: String
    public let xcbuildSignature: String
    public let unknown: Int

    public init(sectionType: Int8,
                domainType: String,
                title: String,
                signature: String,
                timeStartedRecording: Double,
                timeStoppedRecording: Double,
                subSections: [IDEActivityLogSection],
                text: String,
                messages: [IDEActivityLogMessage],
                wasCancelled: Bool,
                isQuiet: Bool,
                wasFetchedFromCache: Bool,
                subtitle: String,
                location: DVTDocumentLocation,
                commandDetailDesc: String,
                uniqueIdentifier: String,
                localizedResultString: String,
                xcbuildSignature: String,
                unknown: Int) {
        self.sectionType = sectionType
        self.domainType = domainType
        self.title = title
        self.signature = signature
        self.timeStartedRecording = timeStartedRecording
        self.timeStoppedRecording = timeStoppedRecording
        self.subSections = subSections
        self.text = text
        self.messages = messages
        self.wasCancelled = wasCancelled
        self.isQuiet = isQuiet
        self.wasFetchedFromCache = wasFetchedFromCache
        self.subtitle = subtitle
        self.location = location
        self.commandDetailDesc = commandDetailDesc
        self.uniqueIdentifier = uniqueIdentifier
        self.localizedResultString = localizedResultString
        self.xcbuildSignature = xcbuildSignature
        self.unknown = unknown
    }

}

public class IDEActivityLogUnitTestSection: IDEActivityLogSection {
    public let testsPassedString: String
    public let durationString: String
    public let summaryString: String
    public let suiteName: String
    public let testName: String
    public let performanceTestOutputString: String

    public init(sectionType: Int8,
                domainType: String,
                title: String,
                signature: String,
                timeStartedRecording: Double,
                timeStoppedRecording: Double,
                subSections: [IDEActivityLogSection],
                text: String,
                messages: [IDEActivityLogMessage],
                wasCancelled: Bool,
                isQuiet: Bool,
                wasFetchedFromCache: Bool,
                subtitle: String,
                location: DVTDocumentLocation,
                commandDetailDesc: String,
                uniqueIdentifier: String,
                localizedResultString: String,
                xcbuildSignature: String,
                unknown: Int,
                testsPassedString: String,
                durationString: String,
                summaryString: String,
                suiteName: String,
                testName: String,
                performanceTestOutputString: String
                ) {
        self.testsPassedString = testsPassedString
        self.durationString = durationString
        self.summaryString = summaryString
        self.suiteName = suiteName
        self.testName = testName
        self.performanceTestOutputString = performanceTestOutputString
        super.init(sectionType: sectionType,
                   domainType: domainType,
                   title: title,
                   signature: signature,
                   timeStartedRecording: timeStartedRecording,
                   timeStoppedRecording: timeStoppedRecording,
                   subSections: subSections,
                   text: text,
                   messages: messages,
                   wasCancelled: wasCancelled,
                   isQuiet: isQuiet,
                   wasFetchedFromCache: wasFetchedFromCache,
                   subtitle: subtitle,
                   location: location,
                   commandDetailDesc: commandDetailDesc,
                   uniqueIdentifier: uniqueIdentifier,
                   localizedResultString: localizedResultString,
                   xcbuildSignature: xcbuildSignature,
                   unknown: unknown)
    }

    private enum CodingKeys: String, CodingKey {
        case testsPassedString
        case durationString
        case summaryString
        case suiteName
        case testName
        case performanceTestOutputString
    }

    /// Override the encode method to overcome a constraint where subclasses properties
    /// are not encoded by default
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(testsPassedString, forKey: .testsPassedString)
        try container.encode(durationString, forKey: .durationString)
        try container.encode(summaryString, forKey: .summaryString)
        try container.encode(suiteName, forKey: .suiteName)
        try container.encode(testName, forKey: .testName)
        try container.encode(performanceTestOutputString, forKey: .performanceTestOutputString)
    }

}

public struct IDEActivityLogMessage: Encodable {
    public let title: String
    public let shortTitle: String
    public let timeEmitted: Double
    public let rangeEndInSectionText: UInt64
    public let rangeStartInSectionText: UInt64
    public let subMessages: [IDEActivityLogMessage]
    public let severity: Int
    public let type: String
    public let location: DVTDocumentLocation
    public let categoryIdent: String
    public let secondaryLocations: [DVTDocumentLocation]
    public let additionalDescription: String
}

public class DVTDocumentLocation: Encodable {
    public let documentURLString: String
    public let timestamp: Double

    public init(documentURLString: String, timestamp: Double) {
        self.documentURLString = documentURLString
        self.timestamp = timestamp
    }

}

public class DVTTextDocumentLocation: DVTDocumentLocation {
    public let startingLineNumber: UInt64
    public let startingColumnNumber: UInt64
    public let endingLineNumber: UInt64
    public let endingColumnNumber: UInt64
    public let characterRangeEnd: UInt64
    public let characterRangeStart: UInt64
    public let locationEncoding: UInt64

    public init(documentURLString: String,
                timestamp: Double,
                startingLineNumber: UInt64,
                startingColumnNumber: UInt64,
                endingLineNumber: UInt64,
                endingColumnNumber: UInt64,
                characterRangeEnd: UInt64,
                characterRangeStart: UInt64,
                locationEncoding: UInt64) {
        self.startingLineNumber = startingLineNumber
        self.startingColumnNumber = startingColumnNumber
        self.endingLineNumber = endingLineNumber
        self.endingColumnNumber = endingColumnNumber
        self.characterRangeEnd = characterRangeEnd
        self.characterRangeStart = characterRangeStart
        self.locationEncoding = locationEncoding
        super.init(documentURLString: documentURLString, timestamp: timestamp)
    }

    private enum CodingKeys: String, CodingKey {
        case startingLineNumber
        case startingColumnNumber
        case endingLineNumber
        case endingColumnNumber
        case characterRangeEnd
        case characterRangeStart
        case locationEncoding
    }

    /// Override the encode method to overcome a constraint where subclasses properties
    /// are not encoded by default
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startingLineNumber, forKey: .startingLineNumber)
        try container.encode(startingColumnNumber, forKey: .startingColumnNumber)
        try container.encode(endingLineNumber, forKey: .endingLineNumber)
        try container.encode(endingColumnNumber, forKey: .endingColumnNumber)
        try container.encode(characterRangeEnd, forKey: .characterRangeEnd)
        try container.encode(characterRangeStart, forKey: .characterRangeStart)
        try container.encode(locationEncoding, forKey: .locationEncoding)
    }
}

public struct IDEConsoleItem: Encodable {
    public let adaptorType: UInt64
    public let content: String
    public let kind: UInt64
    public let timestamp: Double
}

public class DBGConsoleLog: IDEActivityLogSection {
    public let logConsoleItems: [IDEConsoleItem]

    public init(sectionType: Int8,
                domainType: String,
                title: String,
                signature: String,
                timeStartedRecording: Double,
                timeStoppedRecording: Double,
                subSections: [IDEActivityLogSection],
                text: String,
                messages: [IDEActivityLogMessage],
                wasCancelled: Bool,
                isQuiet: Bool,
                wasFetchedFromCache: Bool,
                subtitle: String,
                location: DVTDocumentLocation,
                commandDetailDesc: String,
                uniqueIdentifier: String,
                localizedResultString: String,
                xcbuildSignature: String,
                unknown: Int,
                logConsoleItems: [IDEConsoleItem]) {
        self.logConsoleItems = logConsoleItems
        super.init(sectionType: sectionType,
                   domainType: domainType,
                   title: title,
                   signature: signature,
                   timeStartedRecording: timeStartedRecording,
                   timeStoppedRecording: timeStoppedRecording,
                   subSections: subSections,
                   text: text,
                   messages: messages,
                   wasCancelled: wasCancelled,
                   isQuiet: isQuiet,
                   wasFetchedFromCache: wasFetchedFromCache,
                   subtitle: subtitle,
                   location: location,
                   commandDetailDesc: commandDetailDesc,
                   uniqueIdentifier: uniqueIdentifier,
                   localizedResultString: localizedResultString,
                   xcbuildSignature: xcbuildSignature,
                   unknown: unknown)
    }

    private enum CodingKeys: String, CodingKey {
        case logConsoleItems
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logConsoleItems, forKey: .logConsoleItems)
    }
}
