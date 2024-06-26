from datetime import datetime


def parse_date(date: str, date_format: str = "%Y-%m-%dT%H:%M:%S") -> datetime:
    try:
        return datetime.strptime(date_str, date_format)
    except ValueError as e:
        raise ValueError(
            f"Invalid date format {date_str}. Use {date_format}. Error: {str(e)}"
        )


def normalize_date(date_obj: datetime) -> datetime:
    """Normalize the date to midnight."""
    return datetime(date_obj.year, date_obj.month, date_obj.day)


def time_str(date_obj: datetime):
    """Returns the time in string format."""
    return date_obj.strftime("%H:%M")


def time_frame(date_obj: datetime):
    """Returns the time frame of the day.
    11 pm - 5 am: Night
    5 am - 11 am: Morning (Breakfast)
    11 am - 5 pm: Midday (Lunch)
    5 pm - 11 pm: Evening (Dinner)
    """
    hour = date_obj.hour
    if 23 <= hour or hour < 5:
        return "night"
    elif 5 <= hour < 11:
        return "morning"
    elif 11 <= hour < 17:
        return "midday"
    else:
        return "evening"
