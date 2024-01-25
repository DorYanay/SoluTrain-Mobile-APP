def validate_email(email: str) -> bool:
    if "@" not in email:
        return False
    if "." not in email.split("@")[1]:
        return False
    return True
