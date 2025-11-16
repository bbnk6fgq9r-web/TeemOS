# TeemoCat Neon Overlay

This overlay provides a minimal neon-themed configuration for Teemo Cat Edition.
It includes:
- Openbox config (small rc.xml)
- Simple tint2 panel config
- A neon-style background SVG
- A basic GTK2/3 color theme skeleton
- Minimal icon theme index

How to use:
1. Place or edit your background file at `usr/share/backgrounds/teemocat-neon.svg` or use a JPG/PNG.
2. Modify `root/.config/openbox/rc.xml` and `root/.config/tint2/tint2rc` as needed.
3. To use the overlay in the build, it will be copied into the `teemocat` profile by CI.

Notes:
- This overlay uses lightweight theme fragments only; for a complete GTK icon and widget theme, consider packaging full GTK theme assets.
- Keep large images (icons/fonts) minimal to reduce ISO size.
