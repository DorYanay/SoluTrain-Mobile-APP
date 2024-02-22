def get_api_media_type(name: str) -> str:
    if name.endswith(".pdf"):
        return "application/pdf"
    elif name.endswith(".jpg") or name.endswith(".jpeg"):
        return "image/jpeg"
    elif name.endswith(".png"):
        return "image/png"

    return "application/octet-stream"
