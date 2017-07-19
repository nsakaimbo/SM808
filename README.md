# SM808

## Overview
Basic drum machine sequencer that allows the user to set *kick*, *snare* or *hihat* instruments using 4-, 8-, 16- or 32-step patterns. The visual output is timed to bpm. Sample usage:

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
> PRESET
> Four-on-the-floor loaded
> PLAY
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
|kick|_|hihat|_|kick+snare|_|hihat|_|
> HIHAT ....
> PLAY
|kick|_|_|_|kick+snare|_|_|_|
|kick|_|_|_|kick+snare|_|_|_|
|kick|_|_|_|kick+snare|_|_|_|
|kick|_|_|_|kick+snare|_|_|_|
> QUIT
```
![Output example](/demo.gif?raw=true)

## Installation
The utility can be run directly in the terminal or from Xcode.

Use installation instructions below, or download the compiled binary at [this link](https://drive.google.com/file/d/0B14svRnOP0fIU3dnamg5OGVWcW8/view?usp=sharing) and install to `/usr/local/bin`.

### Requirements
Xcode 8.3.3 and Xcode command line tools

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
 4. `open SM808.xcodeproj` to view and build/run the file in Xcode and interact with the utility in the Xcode's console

## External Dependencies
 * None

## Highlights
Core sequencer functionality is packaged in the **SM808Core** framework with extensibility in mind. The `Voice` type represents the "instrument" being played. The `Song` type comprises an an array of voices. The `DrumMachine` schedules each voice of the passed-in song to play at the appropriate time. Patterns of different durations can be mixed and matched. 

Using a framework facilitates testability and also helps isolate sequencer/domain logic from interface logic. In addition, it also facilitiates reusability (for example, a fun enhancement would be using the **SM808Core** framework in an iOS or MacOS project).

The command-line tool limits user actions to the following commands:
 ```
 enum Command {
  case bpm(bpm: Int)
  case kick(pattern: String)
  case hihat(pattern: String)
  case snare(pattern: String)
  case play
  // Loads a pre-configured "four-on-the-floor" rhythm
  case preset
  case quit
 }
 ```
 The `Command` initializer will `throw` and print to Standard Error when an invalid input is entered by the user.
 
 ## Opportunities for Enhancement
 * Add audio feedback
 * Add unit tests!
