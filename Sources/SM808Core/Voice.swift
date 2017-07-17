//
//  Track.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import Foundation

public struct Voice {
  
  public var name: String
  
  /// Path to audio file resource to be played
  public var audioPath: URL?
  
  /// Indicates wehther the voice should be played at a given tick mark
  fileprivate(set) var pattern: [Bool]
  
  /// Number of ticks in the voice's bar
  private(set) var patternLength: PatternLength
  
  public init?(name: String, pattern: [Bool], audioPath: URL? = nil) throws {
    
    guard let _patternLength = PatternLength(rawValue: pattern.count) else {
      throw Error.invalidPatternLength(reason: "Tick value count must be 4, 8, 16 or 32")
    }
    
    self.name = name
    
    self.audioPath = audioPath
    
    self.pattern = pattern
    
    self.patternLength = _patternLength
  }
  
  public init(name: String, patternLength: PatternLength, audioPath: URL? = nil) {
    
    self.name = name
    self.audioPath = audioPath
    self.patternLength = patternLength
    
    self.pattern = [Bool](repeatElement(false, count: patternLength.rawValue))
  }
}

// MARK: - Mutating Methods
extension Voice {
  
  public mutating func setTickValue(_ value: Bool, atIndex index: Int) throws {
    
    guard Array(pattern.indices).contains(index) else {
      throw Error.invalidPatternIndex(reason: "Cannot set value at index outside of existing bounds: MIN: 0 and MAX: \(pattern.count - 1)")
    }
    
    self.pattern[index] = value
  }
}

// MARK: - Error Definitions
extension Voice {
 
  enum Error: Swift.Error {
    case invalidPatternLength(reason: String)
    case invalidPatternIndex(reason: String)
  }
}

extension Voice.Error: LocalizedError {
  
  var errorDescription: String? {
    switch self {
    case .invalidPatternLength (let reason):
      return reason
    case .invalidPatternIndex (let reason):
      return reason
    }
  }
}
