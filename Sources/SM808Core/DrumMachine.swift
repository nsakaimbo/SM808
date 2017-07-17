//
//  DrumMachine.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import Foundation

public typealias DidTickClosure = (([Voice], _ barStart: Bool, _ barEnd: Bool)->Void)

// Schedules each voice of the passed-in song to play at the appropriate time
public final class DrumMachine {
  
  public var didTick: DidTickClosure?
  
  public var song: Song?
  
  public var repeatCount: Int = 4
  
  private var currentTick: Int = 0
  
  public init(_ song: Song) {
    self.song = song
    self.currentTick = 0
  }
  
  public init() {
    self.song = Song(title: "")
  }
  
  public func play(fromTick tick: Int = 0) throws {
    
    guard let song = song else {
      throw Error.noSong(reason: "Song is not set. Use SONG command to set one.")
    }
    
    guard song.voices.count > 0 else {
      throw Error.noVoices(reason: "No voices for song. Use VOICE command to add at a voice and pattern.")
    }
    
    currentTick = tick
    
    var i = 0
    
    while i < repeatCount {
    
      // Each voice's subdivision will be less than or equal to currentTick (derived from voice with highest subdivision)
      // Want to ensure that shorter patterns are looped in sync with longer ones
      let voicesAtCurrentTick = song.voices.filter { voice in
        
        let patternLength = voice.patternLength.rawValue
        
        if patternLength < longestPatternLength {
          return voice.pattern[currentTick % patternLength]
        }
        else {
          return voice.pattern[currentTick]
        }
      }
      
      let barStart = currentTick == 0
      let barEnd = currentTick == (longestPatternLength - 1)
      
      didTick?(voicesAtCurrentTick, barStart, barEnd)
      
      currentTick = (currentTick + 1) % longestPatternLength
      
      if barEnd {
        i += 1
      }
    }
  }
}

// MARK: - Computed Properties
extension DrumMachine {
  
  /// Returns the length of the longest pattern in array of song voices
  var longestPatternLength: Int {
    return song?.ticksInBar ?? 0
  }
}

// MARK: - Error Definitions
extension DrumMachine {
  
  enum Error: Swift.Error {
    case noSong(reason: String)
    case noVoices(reason: String)
  }
}

extension DrumMachine.Error: LocalizedError {
  
  var errorDescription: String {
    switch self {
    case .noSong(let reason):
      return reason
    case .noVoices (let reason):
      return reason
    }
  }
}
