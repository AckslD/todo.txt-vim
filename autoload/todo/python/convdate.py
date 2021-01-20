import sys
from datetime import datetime, timedelta

NOW = datetime.now()

weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

date_str = ' '.join(sys.argv[1:])
if date_str == "Next week":
    date_str = "Monday"
if date_str == "Today":
    date = NOW
elif date_str == "Tomorrow":
    date = NOW + timedelta(days=1)
elif date_str in weekdays:
    for i in range(8):
        date = NOW + timedelta(days=i)
        if date.strftime("%A") == date_str:
            break
    else:
        raise RuntimeError("Could not convert {date_str}")
else:
    date = datetime.fromisoformat(date_str)

print(date.strftime("%Y-%m-%d"))
