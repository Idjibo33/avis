#!/usr/bin/env python3
"""Génère toutes les icônes de l'app depuis une seule géométrie.

La marque est identique au widget `Logo` : disque noir, couches blanches
(Font Awesome `layer-group`, U+F5FD) et point teal cerclé de blanc en haut à
droite. Aucune autre source d'icône ne doit être modifiée à la main.

Usage : python3 tool/generate_app_icons.py
"""

from __future__ import annotations

import glob
import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

RACINE = Path(__file__).resolve().parent.parent
NOIR = (10, 10, 10, 255)
BLANC = (255, 255, 255, 255)
TEAL = (15, 118, 110, 255)
GLYPHE = chr(0xF5FD)

CIBLES = [
    ("android/app/src/main/res/mipmap-mdpi/ic_launcher.png", 48, 0.80),
    ("android/app/src/main/res/mipmap-hdpi/ic_launcher.png", 72, 0.80),
    ("android/app/src/main/res/mipmap-xhdpi/ic_launcher.png", 96, 0.80),
    ("android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png", 144, 0.80),
    ("android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png", 192, 0.80),
    ("web/icons/Icon-192.png", 192, 0.80),
    ("web/icons/Icon-512.png", 512, 0.80),
    ("web/icons/Icon-maskable-192.png", 192, 0.60),
    ("web/icons/Icon-maskable-512.png", 512, 0.60),
    ("web/favicon.png", 64, 0.80),
]


def trouver_police() -> Path:
    motif = os.path.expanduser(
        "~/.pub-cache/hosted/pub.dev/font_awesome_flutter-*/lib/fonts/"
        "Font-Awesome-7-Free-Solid-900.otf"
    )
    candidats = sorted(glob.glob(motif))
    if not candidats:
        raise SystemExit("Police Font Awesome introuvable : lance `flutter pub get`.")
    return Path(candidats[-1])


def dessiner(taille: int, part_disque: float, police: Path) -> Image.Image:
    # 4x de suréchantillonnage puis réduction : les bords restent nets à 48 px.
    echelle = 4
    n = taille * echelle
    image = Image.new("RGBA", (n, n), BLANC)
    draw = ImageDraw.Draw(image)

    disque = n * part_disque
    milieu = n / 2
    gauche = milieu - disque / 2
    draw.ellipse(
        (gauche, gauche, gauche + disque, gauche + disque),
        fill=NOIR,
    )

    # Même proportion que `Logo` : le glyphe occupe 52 % du disque.
    draw.text(
        (milieu, milieu),
        GLYPHE,
        font=ImageFont.truetype(str(police), int(disque * 0.62)),
        anchor="mm",
        fill=BLANC,
    )

    # Point teal : centre à (0.815, 0.185) du disque, diamètre 0.30,
    # cerclé de blanc de 0.045 — entièrement dans le disque.
    centre_x = gauche + disque * 0.815
    centre_y = gauche + disque * 0.185
    rayon = disque * 0.15
    draw.ellipse(
        (centre_x - rayon, centre_y - rayon, centre_x + rayon, centre_y + rayon),
        fill=BLANC,
    )
    rayon_interne = rayon - disque * 0.045
    draw.ellipse(
        (
            centre_x - rayon_interne,
            centre_y - rayon_interne,
            centre_x + rayon_interne,
            centre_y + rayon_interne,
        ),
        fill=TEAL,
    )

    return image.resize((taille, taille), Image.Resampling.LANCZOS)


def main() -> None:
    police = trouver_police()
    for chemin, taille, part_disque in CIBLES:
        cible = RACINE / chemin
        cible.parent.mkdir(parents=True, exist_ok=True)
        dessiner(taille, part_disque, police).save(cible, optimize=True)
        print(f"{chemin} ({taille}px)")


if __name__ == "__main__":
    main()
