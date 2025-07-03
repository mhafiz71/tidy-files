# Tidy Files v1.0

A powerful Windows batch script for automated file organization and management.

## 🚀 Features

### Organization Methods
- **By Extension** - Organize specific file types (jpg, pdf, txt, etc.)
- **All Common Types** - Auto-sort Images, Documents, Videos, Audio files
- **By Date Modified** - Sort files by modification date
- **By File Size** - Group files into Small/Medium/Large/Huge categories
- **Mixed Organization** - Combine multiple organization strategies *(coming soon)*

### Supported File Types
- **Images**: jpg, jpeg, png, gif, bmp, tiff, svg, webp, ico
- **Documents**: pdf, doc, docx, txt, rtf, odt, xls, xlsx, ppt, pptx
- **Videos**: mp4, avi, mkv, mov, wmv, flv, webm, m4v
- **Audio**: mp3, wav, flac, aac, ogg, m4a, wma
- **Archives**: zip, rar, 7z, tar, gz, bz2
- **Executables**: exe, msi, deb, rpm, dmg

### Additional Tools
- **Status Check** - Analyze folder structure and file counts
- **Operation History** - View logged operations
- **Cleanup Tools** - Remove empty folders and duplicates *(coming soon)*

## 📋 Requirements

- Windows OS (Windows 7 or later)
- Command Prompt with administrative privileges (recommended)

## 🛠️ Installation

1. Download the `tidy-files.bat` file
2. Place it in your desired location
3. Right-click and select "Run as administrator" (recommended)

## 💡 Usage

1. **Run the script** by double-clicking or executing from command prompt
2. **Select organization method** from the main menu (1-5)
3. **Enter source folder path** (or press Enter for current directory)
4. **Follow the prompts** specific to your chosen method
5. **Choose cleanup options** when prompted

### Example Usage
```
Choose a menu option: 1
Enter source folder path: C:\Users\YourName\Downloads
Enter file extension: pdf
Enter custom folder name: Important_PDFs
```

## 🔧 File Size Categories

- **Small Files**: 0-1MB
- **Medium Files**: 1-10MB  
- **Large Files**: 10-100MB
- **Huge Files**: 100MB+

## 📝 Operation Logging

All operations are automatically logged to `tidy-files.log` with:
- Timestamp
- Operation type
- Number of files processed
- Destination folders

## ⚠️ Important Notes

- **Always backup important files** before running organization scripts
- Script creates new folders and moves files (doesn't copy)
- Empty folder removal is optional and prompted
- Use full paths for best results

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is open source. Please see the LICENSE file for details.

## 🆕 Upcoming Features

- Advanced duplicate file removal
- Temporary file cleanup
- Mixed organization methods
- GUI version
- Cross-platform support

## 🐛 Known Issues

- Mixed organization methods are not yet implemented
- Duplicate removal is in development
- Some file extensions may need manual addition

## 📞 Support

If you encounter any issues or have questions:
- Check the built-in help menu (option 9)
- Review the operation history (option 7)
- Submit an issue on GitHub

---

**Made with ❤️ for better file management**
