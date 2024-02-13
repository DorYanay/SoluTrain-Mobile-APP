def validate_email(email: str) -> bool:
    if "@" not in email:
        return False
    if "." not in email.split("@")[1]:
        return False
    return True


def validate_certificate_name(name: str) -> bool:
    if len(name) < 3:
        return False

    if name.startswith("."):
        return False

    return name.endswith(".pdf") or name.endswith(".jpg") or name.endswith(".jpeg") or name.endswith(".png")


def validate_profile_picture_name(name: str) -> bool:
    if len(name) < 3:
        return False

    if name.startswith("."):
        return False

    return name.endswith(".jpg") or name.endswith(".jpeg") or name.endswith(".png")
