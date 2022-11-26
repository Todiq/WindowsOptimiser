@echo off
for %%q in (en-US) do ^
powershell -c "$ll=Get-WinUserLanguageList; $ll.add('%%q'); Set-WinUserLanguageList $ll -force;" & ^
powershell -c "$ll=Get-WinUserLanguageList; $ll.remove(($ll |? LanguageTag -like '%%q')); Set-WinUserLanguageList $ll -force;"