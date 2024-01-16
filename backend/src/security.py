import hashlib


def create_hash(text: str) -> str:
    text_as_bytes = text.encode("utf-8")

    # Hash the password using SHA-256
    hashed_text = hashlib.sha256(text_as_bytes).hexdigest()

    return hashed_text


def verify_hash(text: str, hashed_text: str) -> bool:
    input_password_hashed = create_hash(text)

    return input_password_hashed == hashed_text
