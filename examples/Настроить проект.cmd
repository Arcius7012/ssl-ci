git config --local core.quotepath false
git config --local core.longpaths true
xcopy .\examples\hooks\pre-commit .git\hooks\ /Y /F
xcopy .\examples\hooks\commit-msg .git\hooks\ /Y /F