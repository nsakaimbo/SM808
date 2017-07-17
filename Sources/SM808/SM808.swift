//
//  SM808.swift
//  SM808
//
//  Created by Nicholas Sakaimbo on 7/15/17.
//
//

import SM808Core
import Foundation

final class SM808 {
  
  lazy var consoleIO: IOProviding = ConsoleIO()
  
  lazy var drumMachine = DrumMachine()
  
  lazy var didTick: DidTickClosure = { voices, barStart, barEnd in
    
    if barStart {
      self.consoleIO.write("", terminator: "|")
    }
    
    if voices.count == 0 {
      self.consoleIO.write("_", terminator: "|")
    }
    else {
      let joined = voices.map{$0.name}.joined(separator: "+")
      self.consoleIO.write(joined, terminator: "|")
    }
    
    if barEnd {
      self.consoleIO.write("", terminator: "\n")
    }
  }
  
  private var _isRunning: Bool = true
  
  func run() {
    
    consoleIO.write("Welcome to SM808\n", to: .standard)
    consoleIO.write("- KICK, HIHAT or SNARE with <pattern> to set a 4-, 8-, 16- or 32 step pattern for the instrument", to: .standard)
    consoleIO.write("- Use \"x\" to play instrument at that step, and \".\" to mute, e.g: kick x...x...", to: .standard)
    consoleIO.write("- PLAY for a visual representation of the song (limited to 4 repetitions)", to: .standard)
    consoleIO.write("- PRESET to play a classic \"4-on-the-floor\" sampler", to: .standard)
    consoleIO.write("- QUIT to exit", to: .standard)
    
    drumMachine.didTick = didTick
    
    while _isRunning {
      
      guard let command = consoleIO.getCommand(consoleIO.getInput()) else {
        continue
      }
      
      _runCommand(command)
    }
  }
  
  private func _runCommand(_ command: Command) {
    
    switch command {
      
    case .kick(let pattern):
      drumMachine.song?.removeVoice(named: "kick")
      _addVoice(withName: "kick", andPattern: pattern)
      
    case .hihat(let pattern):
      drumMachine.song?.removeVoice(named: "hihat")
      _addVoice(withName: "hihat", andPattern: pattern)
      
    case .snare(let pattern):
      drumMachine.song?.removeVoice(named: "snare")
      _addVoice(withName: "snare", andPattern: pattern)
      
    case .play:
      
      do {
        try drumMachine.play()
      }
      catch {
        consoleIO.write(error.localizedDescription, to: .error)
      }
      
    case .preset:
      _playPreset()
      
    case .quit:
      _isRunning = false
    }
  }
  
  private func _addVoice(withName name: String, andPattern pattern: String) {
    
    let _pattern = pattern.characters
    
    guard drumMachine.song != nil else {
      consoleIO.write("Song is not set", to: .error)
      return
    }
    
    guard let _patternLength = PatternLength(rawValue: _pattern.count) else {
        consoleIO.write("Number of beats in measure must be 4, 8, 16 or 32", to: .error)
        return
    }
    
    var voice = Voice(name: name, patternLength: _patternLength)
    
    do {
      for (index, c) in _pattern.enumerated() {
        if String(c).lowercased() == "x" {
          try voice.setTickValue(true, atIndex: index)
        }
      }
      
      drumMachine.song?.add(voice)
    }
    catch {
      consoleIO.write("Error setting voice pattern:", to: .error)
    }
  }
  
  private func _playPreset() {
    
    drumMachine.song = nil
    
    let kick = try! Voice(name: "kick", pattern: [true, false, false, false, true, false, false, false])!
    let snare = try! Voice(name: "snare", pattern: [false, false, false, false, true, false, false, false])!
    let hihat = try! Voice(name: "hihat", pattern: [false, false, true, false, false, false, true, false])!
    
    let song = Song(title: "Animal Rights", voices: [kick, snare, hihat])
    
    drumMachine.song = song
    
    try! drumMachine.play()
  }
}
