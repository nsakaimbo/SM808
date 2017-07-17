# SM808

## Overview
Basic drum machine sequencer that allows the user to set *kick*, *snare* or *hihat* instruments using 4-, 8-, 16- or 32-step patterns. For example:

```
> KICK x...x...
> SNARE ....x...
> HIHAT ..x...x.
> PLAY
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
> KICK ....
> PLAY
|_|_|hihat|_|snare|_|hihat|_|
|_|_|hihat|_|snare|_|hihat|_|
|_|_|hihat|_|snare|_|hihat|_|
|_|_|hihat|_|snare|_|hihat|_|
> KICK x...
> PLAY
|kick|_|hihat|_|snare+kick|_|hihat|_|
|kick|_|hihat|_|snare+kick|_|hihat|_|
|kick|_|hihat|_|snare+kick|_|hihat|_|
|kick|_|hihat|_|snare+kick|_|hihat|_|
> QUIT
```
## Installation
The utility can be run directly in the terminal or from Xcode.

### Requirements
Xcode 8.3.3

### Run in Terminal
 1. Clone this repository
 2. In the terminal, `cd` to the root directory of the project and run the following commands:
 3. `$ swift build -c release -Xswiftc -static-stdlib` to compile the executable in release mode
 4. `cd .build/release`
 5. `$ cp -f SM808 /usr/local/bin/SM808` to copy the executable to `/usr/local/bin` 
 6. Now from any terminal session, you can enter `SM808` to run the tool, `CTRL+C` to quit 

### Run/View in Xcode
 1. Clone this repository
 2. In the terminal, `cd` to the root directory of the project and run the following commands:
 3. `$ swift package generate-xcodeproj` to generate the Xcode project file
 4. `open SM808.xcodeproj` to view and build/run the file in Xcode

## External Dependencies
 * None

## Highlights
Core sequencer functionality is packaged in the **SM808Core** framework with extensibility in mind. The `Voice` type is designed to take on any name and even includes an optional  audio file URL. The `Song` type comprises an an array of voices. The `DrumMachine` schedules each voice of the passed-in song to play at the appropriate time. Patterns of different durations can be mixed and matched. 

The command-line tool limits user actions to the following commands:
 ```
 enum Command {
  case kick(pattern: String)
  case hihat(pattern: String)
  case snare(pattern: String)
  case play
  // Plays a pre-configured "four-on-the-floor" rhythm
  case preset
  case quit
 }
 ```
 The `Command` initializer will `throw` and print to Standard Error when an invalid input is entered by the user.
 
 ## Opportunities for Enhancement
 * Add unit tests!
 * Implement bpm so output is driven with respect to tempo
 * A fun enhancement would be making use of the **SM808Core** framework in an iOS or MacOS project with a more visually-rich interface.
