$appName = "testapp"
$version = $args[0]

Remove-Item "./build/app/outputs/flutter-apk" -Recurse

flutter build apk --split-per-abi

$names = Get-ChildItem -Path "./build/app/outputs/flutter-apk" -Name
foreach ($name in $names) {
    $newName = $name.replace("app-", "$appName-")
    $newName = $newName.replace("release", $version)
    Rename-Item -Path "./build/app/outputs/flutter-apk/$name" -NewName $newName
}