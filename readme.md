# walldrive
Set wallpaper using walldrive and a csv file
> Recommended using with Google drive
## Dependencies
* wal (python)
* sxiv
* curl
* awk
* mktemp
## How to use with Google drive
1. Make a new spreadsheet
2. Go to `Tools` ---> `Script editor`
3.  paste the below code in the editor 
```
// this script just append the essential column needed for the script to run
// remember to excute this script on a empty sheet or you will lose data on that perticular sheet
function  myFunction() {
	var  ss=SpreadsheetApp.getActiveSpreadsheet();
	var  file, data, sheet = ss.getActiveSheet();
	sheet.clear()
	var  folder = DriveApp.getFolderById("<folder id here>");
	var  files=folder.getFiles();
	while (files.hasNext()) {
		file = files.next();
		data = [
			file.getName(),
			file.getDownloadUrl(),
			'https://lh3.googleusercontent.com/d/'+ file.getId() +'=w320?authuser=0',
			file.getSize()
		];
	sheet.appendRow(data);
	}
}
// excute this script
```
4. Download the `csv` file
5. clone the repo and cd into the repo
7. run the script as  `walldrive -r 10 -f 7 -s ./Example/wallpaper.csv`
	* -r (range) number of pics you want to display
	* -f (from) what should be starting pic number
	* -s (source) source file this must be a `csv` file

## Note
* The script will only download and apply photo as as wallpaper which is marked first.
## Example
* A `csv` file is already in the example folder
