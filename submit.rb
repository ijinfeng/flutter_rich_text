
#! /usr/bin/ruby


system('git status -s')
system('git add .')
system("git commit -m 'update'")
system('git pull --rebase origin main')
system('git push origin main')
