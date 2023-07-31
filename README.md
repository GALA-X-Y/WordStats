# **Word Stats 1.2.2**

<img src="https://i.imgur.com/fB0GpnW.png" width="250">

## Introduction
**Word Stats** is a composition analyzer software designed to generate statistical information about English compositions. 

Features of **Word Stats** :
- Open Source
- Using *Pascal* as Programming Language
- Well-Structured Functions and Procedures

By selecting the text file to be read, users may get results like :
- frequencies of letters
- frequency of a given word/expression
- total number of words and paragraphs

Furthermore, **Word Stats** provides users with customizable result return methods : 
- append results in original text file
- output results in another text file

## How to Use **Word Stats**
1. Open <kbd>wordstats.exe</kbd>.
2. Enter the **Path** of the **Folder**[^1] contain text files to be read.
3. Select the next action to be taken from the main menu.
> #### Main Menu
>1. Get frequencies of letters
>2. Get total number of words and paragraphs
>3. Get frequency of a given word/expression
>4. Program Preference (See "**Change Path and Output Mode**")
>5. Quit
4. Enter the file name of text file to be read. [^2]
5. Result will be shown on terminal, select the output mode (If have not been set in `Program Preference`)
6. To exit the program, choose `Quit` option in main menu.
### Change Path and Output Mode
By choosing `Program Preference` in main menu, another menu will be shown.
1. Change Destination Path [^1]
2. Result Return Preference

Choosing `Change Destination Path` will ask users to enter a new destination Path.

Choosing set `Result Return Preference` will ask users to choose one from the followings :
1. Always Append Result in Original File
2. Always Return Result in Another File
3. Always Ask After Runs
4. Never Record Result in Text File

The default result return mode is 3: Always Ask After Runs. [^3]

## Modification 
For users who know [*Pascal*](https://www.tutorialspoint.com/pascal/index.htm) Language and hope to :
- perform personal modification.
- use functions and proceduces from the source file in other program. [^4]

You can edit the source file <kbd>wordstats.pas</kbd> in any IDE you like.

Make sure you have a *Pascal* compiler software. Here are some examples :
- [Free Pascal](https://www.freepascal.org/download.html) (Recommended)
- [Dev-Pascal IDE](https://www.bloodshed.net/Dev-Pascal) (Compiler Integrated)
- [Lazarus](https://www.lazarus-ide.org) 
- [GNU Pascal](https://www.gnu-pascal.de/gpc/h-index.html)

### Component Functions and Procedures
    Print_List()

This is a procedure.

Shows main menu for users' selection and undergoes file select section.

This is the base procedure that control whole program workflow according to users selections and it calls most functions and procedures.

**Raises:**
- **OutofRangeError** - Users' invalid input that mismatch from the main menu.
- **FileNotFoundError** - Users input wrong filename or Path in file select section.

```
Print_PList()
```

This is a procedure.

Shows `Program Preference` menu.

This is the procedure called by `Print_List()` to perform path changing and result return preference setting.

**Raises:**
- **OutofRangeError** - Users' invalid input that mismatch from the `Program Preference` menu.

```
Word_Count(rfname)
```

This is a procedure.

Count the total number of words in the selected text file.

This procedure include result output section.

**Parameters:**
- **rfname**(String) : The file name of the selected text file.

**Raises:**
- **OutofRangeError** - Users' invalid input that mismatch from the result return menu.
- **FileNotFoundError** - Users input wrong filename or Path in output file select section.

```
Word_Freq(rfname)
```

This is a procedure.

Count the frequencies of input words in the selected text file.

This procedure include expression input and result output sections.

**Parameters:**
- **rfname**(String) : The file name of the selected text file.

**Raises:**
- **OutofRangeError** - Users' invalid input that mismatch from the result return menu.
- **FileNotFoundError** - Users input wrong filename or Path in output file select section.

```
Char_Freq(rfname)
```

This is a procedure.

Count the frequencies of each existed letters in the selected text file.

This procedure include result output section.

**Parameters:**
- **rfname**(String) : The file name of the selected text file.

**Raises:**
- **OutofRangeError** - Users' invalid input that mismatch from the result return menu.
- **FileNotFoundError** - Users input wrong filename or Path in output file select section.

```
CheckWordFinished(S, I)
```

This is a function.

Check the end of words by checking whether a digit is space, comma, or fullstop.

This function is used in `Word_Count()` and `Word_Freq()`.

**Parameters:**
- **S**(String) : The whole string to be checked.
- **I**(Integer) : The index of the digit to be checked.

**Raises:**
- **OutofRangeError** - The index inputted is larger than the length of the string.

[^1]: The path should be the **folder** contain the text file, not the direct  path to the text file. Or otherwise the program will stuck at file select section.  
[^2]: You can type "last" to refer to previous text file name input. (Cannot be use in first run)  
[^3]: This will be reset to default after the executable restart.  
[^4]: This is an academic project. **Never** use it for commercial purpose.  
