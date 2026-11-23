"""Local runtime settings, with shell variables taking precedence over .env."""

import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import dotenv_values

PROJECT_ROOT = Path(__file__).resolve().parent.parent


@dataclass(frozen=True)
class Settings:
    database: Path
    api_key: str = ""
    model: str = "gpt-4.1-mini"
    port: int = 8000
    secret_key: str = ""

    @classmethod
    def from_environment(cls) -> "Settings":
        env = {**dotenv_values(PROJECT_ROOT / ".env"), **os.environ}
        port = int(env.get("APP_PORT") or "8000")
        if not 1 <= port <= 65_535:
            raise ValueError("APP_PORT must be between 1 and 65535.")
        return cls(
            database=PROJECT_ROOT / (env.get("RETURNS_DB_PATH") or ".data/returns.sqlite3"),
            api_key=(env.get("OPENAI_API_KEY") or "").strip(),
            model=(env.get("OPENAI_MODEL") or "gpt-4.1-mini").strip(),
            port=port,
            secret_key=env.get("APP_SECRET_KEY") or "",
        )
