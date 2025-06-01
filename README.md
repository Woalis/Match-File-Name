# 📑 Match-File-Name
Matches a target file name to a source file, while also adding fields for prefix and suffix text. The target modified date will match the source's modified date. The source and target files retain their original file extensions.

## ✨ Usage
Copy the PowerShell and Batch script into a directory, and double click the batch script. This will open a command prompt window in the background and a GUI window in the foreground with 4 fields:
- Source: Drag and drop a file in here.
- Target: Drag and drop a file in here.
- Prefix: Enter text if desired. There is no character delimiter, so add one if you want.
- Suffix: Enter text if desired. There is no character delimiter, so add one if you want.

There are two buttons:
- Run: Starts the renaming process.
- Clear: Clears the fields.

## 📜 Why?
I had a need to add associated data with a file, but the file name of the second file would end up different than the first. To make it easier to associate them together, I wanted to name them the same and have the modified dates the same. This makes file sorting in a browser easier.

## 📝 License
The Batch script code was shared by [Daniel Schroeder](https://github.com/deadlydog) in a really educational [blog post](https://blog.danskingdom.com/allow-others-to-run-your-powershell-scripts-from-a-batch-file-they-will-love-you-for-it/) [under](https://blog.danskingdom.com/about/#-license) the [Creative Commons 4.0 License](https://creativecommons.org/licenses/by/4.0/).

The PowerShell script was developed in conjunction with ChatGPT.
