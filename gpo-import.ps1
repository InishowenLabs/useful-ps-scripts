# Created by John Penford
# Taken from https://johnpenford.wordpress.com/2015/02/27/import-gpos-from-one-domain-to-another-using-powershell/
# Imports GPOs from a folder name
# User is prompted to select the from from which to import the GPOs
Import-Module ActiveDirectory            
Import-Module GroupPolicy  
$app = new-object -com Shell.Application
$folder = $app.BrowseForFolder(0, "Select Folder", 0, "C:\")
$GPOFolderName = $folder.Self.Path
$import_array = get-childitem $GPOFolderName | Select name
foreach ($ID in $import_array) {
    $XMLFile = $GPOFolderName + "\" + $ID.Name + "\gpreport.xml"
    $XMLData = [XML](get-content $XMLFile)
    $GPOName = $XMLData.GPO.Name
    import-gpo -BackupId $ID.Name -TargetName $GPOName -path $GPOFolderName -CreateIfNeeded
}
