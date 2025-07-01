# GoPro Date Fixer

AppleScript automation to correct and synchronize date metadata on GoPro photos and videos.  
This script updates EXIF and QuickTime metadata fields and ensures macOS Finder displays the correct "Date Created".

## ✨ Features

- ✅ Works on GoPro JPG/JPEG, PNG, MP4, MOV, LRV, and THM files
- 🕒 Shift timestamps by any number of days (forward or backward)
- 📅 Set a specific date while preserving the original time-of-day
- 🧠 Automatically handles multiple video timestamp fields:
  - `CreateDate`, `ModifyDate`
  - `TrackCreateDate`, `TrackModifyDate`
  - `MediaCreateDate`, `MediaModifyDate`
  - `Keys:CreationDate`
- 🖥 Syncs macOS Finder's `Date Created` via `SetFile`

## 📦 Requirements

- [exiftool](https://exiftool.org/) – install via Homebrew:

  ```bash
  brew install exiftool
