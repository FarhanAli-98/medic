"""Image metadata and the structured inspection boundary."""

from dataclasses import dataclass
from typing import Literal

from pydantic import BaseModel, ConfigDict, model_validator

View = Literal["front-right", "top", "back"]
VIEWS = {"front-right": "Front and right", "top": "Top", "back": "Back"}
OUTCOMES = {
    "damage_confirmed": "Damage confirmed",
    "no_visible_damage": "No visible damage",
    "inconclusive": "Inconclusive",
}


@dataclass(frozen=True)
class Photo:
    view: str
    width: int
    height: int
    jpeg: bytes


class EvidenceBox(BaseModel):
    model_config = ConfigDict(extra="forbid")
    x: float
    y: float
    width: float
    height: float

    @model_validator(mode="after")
    def within_image(self) -> "EvidenceBox":
        if not (
            0 <= self.x < 1 and 0 <= self.y < 1
            and 0 < self.width <= 1 - self.x and 0 < self.height <= 1 - self.y
        ):
            raise ValueError("Evidence box must fit inside the image.")
        return self


class Finding(BaseModel):
    model_config = ConfigDict(extra="forbid")
    view: View
    verdict: Literal["possible_damage", "no_visible_damage", "unclear"]
    observation: str
    box: EvidenceBox | None


class InspectionReport(BaseModel):
    model_config = ConfigDict(extra="forbid")
    summary: str
    findings: list[Finding]
