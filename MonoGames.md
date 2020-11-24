# 起動しない

```
[ERROR] FATAL UNHANDLED EXCEPTION: System.TypeInitializationException: The type initializer for 'System.Console' threw an exception. ---> System.TypeInitializationException: The type initializer for 'System.ConsoleDriver' threw an exception. ---> System.Exception: Magic number is wrong: 542
  at System.TermInfoReader.ReadHeader (System.Byte[] buffer, System.Int32& position) <0x413a4000 + 0x00127> in <filename unknown>:0
  at System.TermInfoReader..ctor (System.String term, System.String filename) <0x413a3e40 + 0x00127> in <filename unknown>:0
  at System.TermInfoDriver..ctor (System.String term) <0x413a2d90 + 0x00193> in <filename unknown>:0
  at System.ConsoleDriver.CreateTermInfoDriver (System.String term) <0x413a2d50 + 0x00027> in <filename unknown>:0
  at System.ConsoleDriver..cctor () <0x413a2a60 + 0x000a7> in <filename unknown>:0
  --- End of inner exception stack trace ---
  at System.Console.SetupStreams (System.Text.Encoding inputEncoding, System.Text.Encoding outputEncoding) <0x413a2410 + 0x00043> in <filename unknown>:0
  at System.Console..cctor () <0x413a2120 + 0x00173> in <filename unknown>:0
  --- End of inner exception stack trace ---
  at StardewValley.Game1.set_gameMode (Byte value) <0x413a4c70 + 0x00053> in <filename unknown>:0
  at StardewValley.Program.handleException (System.Object sender, System.UnhandledExceptionEventArgs args) <0x413a48d0 + 0x00047> in <filename unknown>:0
```

なぜか TERM=xterm を付けると起動する
https://stackoverflow.com/questions/49242075/mono-bug-magic-number-is-wrong-542
