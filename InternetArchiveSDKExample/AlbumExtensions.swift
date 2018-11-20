//
//  ConcertExtensions.swift
//  InternetArchiveSDKExample
//
//  Created by Jason Buckner on 11/13/18.
//  Copyright © 2018 Jason Buckner. All rights reserved.
//

import Foundation
import InternetArchiveSDK

extension InternetArchive.Item {
  // this goes through all of the files in an item, filters by `VBR MP3` format, then sorts by `track`
  var sortedTracks: [InternetArchive.File] {
    let onlyTracks: [InternetArchive.File] = self.files?.filter { $0.format == "VBR MP3" } ?? []
    let sortedTracks: [InternetArchive.File] = onlyTracks.sorted { (song: InternetArchive.File, song2: InternetArchive.File) -> Bool in
      guard
        let track1: Int = Int(song.track ?? "0"),
        let track2: Int = Int(song2.track ?? "0") else { return false }

      // If we have matching track numbers, it may mean track numbers were not provided. Try sorting by track
      // title. Sometimes recorders will prefix the track number on the title. It's better than nothing
      if track1 == track2 {
        return song.title ?? "" < song2.title ?? ""
      } else {
        return track1 < track2
      }
    }
    return sortedTracks
  }
}

extension InternetArchive.ItemMetadata {
  var normalizedDate: Date? {
    return dateParser.date(from: self.date ?? "")
  }
}

private let dateParser: ISO8601DateFormatter = ISO8601DateFormatter()
