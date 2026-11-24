"""Lay out captioned panels side by side: compose.py OUT IMG "Heading" "Body" [IMG "Heading" "Body" ...]"""
import sys, textwrap
from PIL import Image, ImageDraw, ImageFont

BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
REG  = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
out, args = sys.argv[1], sys.argv[2:]
panels = [args[i:i+3] for i in range(0, len(args), 3)]
W, H, top, gap = 700, 506, 190, 10
img = Image.new("RGB", (len(panels)*(W + gap) + gap, H + top + 20), "#f8f8f8")
d = ImageDraw.Draw(img)
for i, (f, head, body) in enumerate(panels):
    x = gap + i*(W + gap)
    d.text((x + 14, 16), head, font=ImageFont.truetype(BOLD, 34), fill="#1d3557")
    y = 66
    for line in textwrap.wrap(body, 44):
        d.text((x + 14, y), line, font=ImageFont.truetype(REG, 24), fill="#333"); y += 31
    img.paste(Image.open(f).convert("RGB").resize((W, H)), (x, top))
    d.rectangle([x, top, x + W - 1, top + H - 1], outline="#ccc", width=2)
img.save(out)
