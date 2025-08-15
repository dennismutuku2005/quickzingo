from PIL import Image

# Input file (replace with your actual file path)
img_path = "./assets/splash/splash_icon.png"

# Open image
img = Image.open(img_path).convert("RGBA")

# Set margin size
margin = 200

# Create new canvas with yellow background
new_size = (img.width + 2*margin, img.height + 2*margin)
new_img = Image.new("RGBA", new_size, (255, 205, 0, 255))  # yellow background

# Paste the original image in the middle
new_img.paste(img, (margin, margin), img)

# Save output
output_path = "icon_with_margin_bg.png"
new_img.save(output_path, "PNG")

print(f"Saved: {output_path}")
