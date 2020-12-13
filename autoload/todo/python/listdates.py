from datetime import datetime, timedelta

NUM_DAYS = 365
NOW = datetime.now()

special = ["Today", "Tomorrow", "Next week"]
weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
absolute = [(NOW + timedelta(days=i)).strftime("%Y-%m-%d") for i in range(365)]
dates = special + weekdays + absolute
for date in dates:
    print(date)
