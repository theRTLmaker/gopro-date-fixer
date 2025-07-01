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
  ```

## 🚀 Usage

1. Open the script with **Script Editor** on macOS.
2. Run the script.
3. Select one or more GoPro files when prompted.
4. Choose between:
   - **Shift Date** – move the timestamp by ±N days
   - **Set Date** – define a specific date (preserving the time-of-day)
5. The script will update the relevant metadata and sync Finder's **Date Created** field.

---

## 🔒 Notes

- MP4/MOV files from GoPro often contain multiple conflicting metadata timestamps.  
  This script corrects all of them.
- THM files don’t contain EXIF metadata — only Finder dates are updated.
- **Backup your files** before bulk-running the script.

---

## 📁 File Support

| Format         | Supported | Metadata Edited              | Finder Date |
|----------------|-----------|-------------------------------|--------------|
| `.jpg`, `.jpeg`| ✅         | EXIF: `DateTimeOriginal`      | ✅           |
| `.png`         | ✅         | EXIF: `DateTimeOriginal`      | ✅           |
| `.mp4`, `.mov` | ✅         | QuickTime/EXIF multi-field    | ✅           |
| `.lrv`         | ✅         | Treated like `.mp4`           | ✅           |
| `.thm`         | ✅         | No metadata, just Finder date | ✅           |

---

## 🛠 Example

Running this script on a folder of GoPro files can correct their sorting and display in:

- macOS **Finder**
- macOS **Photos** app
- **iCloud**
- **Adobe Lightroom**
