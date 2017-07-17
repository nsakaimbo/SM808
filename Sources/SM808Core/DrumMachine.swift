//
//  DrumMachine.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import CoreFoundation
import Foundation

public typealias DidTickClosure = (([Voice], _ barStart: Bool, _ barEnd: Bool)->Void)

// Schedules each voice of the passed-in song to play at the appropriate time
public final class DrumMachine {
  
  public var didTick: DidTickClosure?
  
  public var song: Song?
  
  public var bpm: Int = 128
  
  /// Number of times we'll allow the bar to loop
  public var repeatCount: Int = 4
  private var _currentLoopCount: Int = 0
  
  private var currentTick: Int = 0
  
  private var _runLoop: RunLoop!
  private var _timer: Timer!
  
  public init(_ song: Song) {
    self.song = song
    self.currentTick = 0
  }
  
  public init() {
    self.song = Song(title: "")
  }
  
  @objc func scheduleTick(_ timer: Timer) {
    
    guard let song = song else { return }
    
    guard _currentLoopCount < repeatCount else {
      _timer?.invalidate()
      _timer = nil
      
      CFRunLoopStop(CFRunLoopGetCurrent())
      _currentLoopCount = 0
      return
    }
    
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
      
      self.didTick?(voicesAtCurrentTick, barStart, barEnd)
      
      currentTick = (currentTick + 1) % longestPatternLength
      
      if barEnd {
        _currentLoopCount += 1
      }
  }
  
  public func play(fromTick tick: Int = 0) throws {
    
    guard let song = song else {
      throw Error.noSong(reason: "Song is not set")
    }
    
    guard song.voices.count > 0 else {
      throw Error.noVoices(reason: "No voices set for song")
    }
    
    currentTick = tick
    
    if _runLoop == nil { _runLoop = RunLoop.current }

    _timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(scheduleTick(_:)), userInfo: nil, repeats: true)
    _runLoop.add(_timer, forMode: .defaultRunLoopMode)
    
    _runLoop.run(mode: .defaultRunLoopMode, before: .distantFuture)
    _timer?.fire()
  }
}

// MARK: - Computed Properties
extension DrumMachine {
  
  /// Returns the length of the longest pattern in array of song voices
  var longestPatternLength: Int {
    return song?.ticksInBar ?? 0
  }
  
  var interval: Double {
    if longestPatternLength == 0 {
      return 0
    }
    return ((60 / (Double(bpm)) * 4) / Double(longestPatternLength))
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
