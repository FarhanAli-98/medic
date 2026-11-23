"""Normalize submitted photos before persistence or provider access."""

from io import BytesIO

from PIL import Image, ImageOps, UnidentifiedImageError

from .models import Photo

MAX_UPLOAD = 5 * 1024 * 1024
MAX_PIXELS = 25_000_000
ACCEPTED_FORMATS = {"JPEG", "PNG", "WEBP"}


class InvalidPhoto(ValueError):
    pass


def normalize_photo(view: str, content: bytes) -> Photo:
    if not content or len(content) > MAX_UPLOAD:
        raise InvalidPhoto("Use a JPEG, PNG, or WebP photo up to 5 MB.")
    try:
        with Image.open(BytesIO(content)) as original:
            width, height = original.size
            if original.format not in ACCEPTED_FORMATS or getattr(original, "is_animated", False):
                raise InvalidPhoto("Use a still JPEG, PNG, or WebP photo.")
            if width * height > MAX_PIXELS or min(width, height) < 240:
                raise InvalidPhoto("Use a photo under 25 megapixels and at least 240 pixels per side.")
            image = ImageOps.exif_transpose(original).convert("RGB")
    except (UnidentifiedImageError, OSError, Image.DecompressionBombError) as error:
        raise InvalidPhoto("This file could not be opened as a photo.") from error

    image.thumbnail((1440, 1440), Image.Resampling.LANCZOS)
    buffer = BytesIO()
    image.save(buffer, "JPEG", quality=88, optimize=True)
    return Photo(view, image.width, image.height, buffer.getvalue())
