//
//  Song.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import Foundation

public struct Song {
  
  var title: String
  
  private(set) var voices: [Voice]
  
  public init(title: String, voices: [Voice] = []) {
    self.title = title
    self.voices = voices
  }
  
  /// Returns the length of the longest pattern from array of voices
  var ticksInBar: Int {
    
    let sorted = voices
      .map{$0.patternLength.rawValue}
      .sorted{$0 < $1}
    
    guard let last = sorted.last else { return 0 }
    
    return last
  }
  
  public mutating func removeVoice(named name: String) {
    voices = voices.filter{ $0.name != name }
  }
  
  public mutating func add(_ voice: Voice) {
    voices.append(voice)
  }
}
