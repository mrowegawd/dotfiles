#!/usr/bin/python
import json
import subprocess

from tasklib import TaskWarrior  # pip install tasklib

outfile = "/home/mr00x/.reminders"

reminders = "# Taskwarrior Tasks with Due Dates\n"

task = TaskWarrior("~/.task")
for t in json.loads(subprocess.check_output(["task", "+DUE", "+UNBLOCKED", "export"])):

    time_stamp = task.convert_datetime_string(t["due"])
    # print(time_stamp)
    reminders += 'REM %s-%s-%s AT %s:%s MSG %%"%s%%" (taskwarrior)\n' % (
        t["due"][:4],
        t["due"][4:6],
        str(time_stamp)[8:10],
        str(time_stamp)[11:13],
        str(time_stamp)[14:16],
        t["description"],
    )


# print(reminders)

with open(outfile, "r") as f:
    # compare file with reminders string
    if reminders != f.read():
        # write new file only if it differs from existing file
        with open(outfile, "w") as o:
            o.write(reminders)
