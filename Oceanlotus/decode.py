import png
def get_rgba(w, h, pixels, x, y):
“””Get RGBA pixel DWORD from x, y”””
    pos = x + y * w
    pixel = pixels[pos * 4 : (pos + 1) * 4]
    return pixel[0], pixel[1], pixel[2], pixel[3]
def decode_pixel(w, h, pixels, x, y):
“””Get RGBA pixel DWORD at x, y and decode to BYTE”””
    r, g, b, a = get_rgba(w, h, pixels, x, y)
    return (r & 7 | 8 * (8 * b | g & 7)) & 0xff
# Open payload image
w, h, pixels, metadata = png.Reader(filename=”payload.png”).read_flat()
size = 0
x = 0
y = 0
# Decode size of payload
while x < 4:
    size = (size >> 8) | decode_pixel(w, h, pixels, x, y) << 24
    x = x + 1
print(hex(size))
# Decode first row
while x < w:
    print(hex(decode_pixel(w, h, pixels, x, y)))
    x = x + 1
