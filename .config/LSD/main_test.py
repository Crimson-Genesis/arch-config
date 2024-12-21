import numpy as np
from scipy.linalg import lstsq


# MSB Prediction using Orthogonal Projection
def msb_prediction(image):
    predicted_image = np.zeros_like(image)

    rows, cols = image.shape

    for row in range(1, rows):
        for col in range(1, cols):
            # Predict the pixel value using neighboring pixels (left, top, and top-left)
            neighbors = [
                image[row, col - 1],  # Left
                image[row - 1, col],  # Top
                image[row - 1, col - 1],  # Top-left diagonal
            ]

            weights = np.array([0.33, 0.33, 0.33])  # Simple equal weight projection
            predicted_pixel = np.dot(neighbors, weights)
            predicted_image[row, col] = np.clip(predicted_pixel, 0, 255)

    return predicted_image.astype(np.uint8)


# XOR encryption for simplicity
def encrypt_image(image, key=123):
    np.random.seed(key)
    random_bits = np.random.randint(0, 256, size=image.shape, dtype=np.uint8)
    encrypted_image = np.bitwise_xor(image, random_bits)
    return encrypted_image


# Apply MSB prediction to each channel (R, G, B)
def predict_and_encrypt_color_image(image):
    encrypted_image = np.zeros_like(image)
    for channel in range(3):
        predicted_channel = msb_prediction(image[:, :, channel])
        encrypted_image[:, :, channel] = encrypt_image(predicted_channel)
    return encrypted_image


# Matrix encoding technique for data embedding
# def matrix_encoding(block, data_bits):
#     parity_matrix = np.array([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
#     syndrome = np.dot(block, parity_matrix.T) % 2
#     if np.array_equal(syndrome, data_bits):
#         return block  # No changes needed
#     else:
#         for i in range(len(block)):
#             modified_block = np.copy(block)
#             modified_block[i] = 1 - block[i]  # Flip a bit
#             if np.array_equal(np.dot(modified_block, parity_matrix.T) % 2, data_bits):
#                 return modified_block
#     return block  # Fallback (shouldn't reach here)
def matrix_encoding(block, data_bits):
    # Ensure the block is only 3 bits for this encoding step
    parity_matrix = np.array([[0, 0, 1], [0, 1, 0], [1, 0, 0]])

    # We are only working on 3 bits at a time for matrix encoding
    block = block[:3]  # Take the first 3 bits of the block

    # Compute the syndrome (error check) by dotting the block with the parity matrix
    syndrome = np.dot(block, parity_matrix.T) % 2

    # If the syndrome matches the data bits, no change is needed
    if np.array_equal(syndrome, data_bits):
        return block  # Return the block as it is
    else:
        # Flip a bit in the block to match the syndrome
        for i in range(len(block)):
            modified_block = np.copy(block)
            modified_block[i] = 1 - block[i]  # Flip the ith bit
            if np.array_equal(np.dot(modified_block, parity_matrix.T) % 2, data_bits):
                return modified_block

    # If no modification is found, return the original block (shouldn't normally happen)
    return block


# Embedding secret data using matrix encoding in MSBs
# def embed_data_matrix_encoding(image, secret_data):
#     flat_image = image.flatten()
#     data_bits = np.unpackbits(np.array(secret_data, dtype=np.uint8))
#     idx = 0
#
#     for i in range(0, len(flat_image), 7):
#         block = np.unpackbits(np.array(flat_image[i : i + 7], dtype=np.uint8))
#         if idx + 3 <= len(data_bits):
#             block = matrix_encoding(block, data_bits[idx : idx + 3])
#             flat_image[i : i + 7] = np.packbits(block)
#             idx += 3
#
#     return flat_image.reshape(image.shape)


def embed_data_matrix_encoding(image, secret_data):
    # Convert secret data to bytes if it is not in byte form
    if isinstance(secret_data, str):
        secret_data = secret_data.encode("utf-8")  # Convert to bytes if it's a string

    # Convert secret_data (which is now a byte string) into an array of bits
    data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
    data_bits = np.unpackbits(data_bytes)

    flat_image = image.flatten()
    idx = 0

    for i in range(
        0, len(flat_image), 1
    ):  # Iterate through the image 1 byte (8 bits) at a time
        # Take only the MSB of each byte for matrix encoding
        block = np.unpackbits(np.array([flat_image[i]], dtype=np.uint8))[
            :3
        ]  # Only take 3 bits (MSB)

        if idx + 3 <= len(data_bits):
            # Perform matrix encoding on this 3-bit block
            encoded_block = matrix_encoding(block, data_bits[idx : idx + 3])
            packed_block = np.packbits(
                np.pad(encoded_block, (0, 5), constant_values=0)
            )  # Pack back into 8-bit

            flat_image[i] = packed_block[0]  # Store the modified byte
            idx += 3

    return flat_image.reshape(image.shape)


# Histogram shifting for data embedding
def histogram_shift(image_channel, data_bits):
    hist, bins = np.histogram(image_channel.flatten(), bins=256, range=(0, 255))
    zero_bin = np.argmin(hist)  # Shift around the minimum histogram value

    shifted_channel = np.copy(image_channel)
    idx = 0
    for i in range(image_channel.shape[0]):
        for j in range(image_channel.shape[1]):
            pixel = image_channel[i, j]
            if idx < len(data_bits) and (pixel == zero_bin or pixel == zero_bin + 1):
                if data_bits[idx] == 1:
                    shifted_channel[i, j] += 1
                idx += 1

    return shifted_channel


# Second-layer embedding using Histogram Shifting
# def embed_data_histogram_shifting(image, secret_data):
#     for channel in range(3):  # R, G, B
#         channel_data = image[:, :, channel].flatten()
#         data_bits = np.unpackbits(np.array(secret_data, dtype=np.uint8))
#         image[:, :, channel] = histogram_shift(channel_data, data_bits)
#
#     return image
def embed_data_histogram_shifting(image, secret_data):
    # Convert secret data to bytes if it's not in byte form
    if isinstance(secret_data, str):
        secret_data = secret_data.encode("utf-8")  # Convert to bytes if it's a string

    # Convert secret_data (now a byte string) into an array of bits
    data_bytes = np.frombuffer(secret_data, dtype=np.uint8)
    data_bits = np.unpackbits(data_bytes)

    # Loop over the color channels (Red, Green, Blue)
    for channel in range(3):  # Assuming image has 3 color channels (RGB)
        channel_data = image[:, :, channel].flatten()  # Flatten the 2D channel data
        idx = 0

        # Embed bits into the image using histogram shifting
        for i in range(len(channel_data)):
            if idx < len(data_bits):
                if channel_data[i] % 2 == 0:  # Simple example: embed data in LSB
                    channel_data[i] += data_bits[idx]  # Add the bit to the pixel value
                else:
                    channel_data[i] -= data_bits[
                        idx
                    ]  # Subtract the bit (ensure minimal change)
                idx += 1

        # Reshape back to the original image dimensions
        image[:, :, channel] = channel_data.reshape(image[:, :, channel].shape)

    return image


# Full encoding process
def encode_image(image, secret_data):
    encrypted_image = predict_and_encrypt_color_image(image)

    # First layer: Embed data using matrix encoding
    encoded_image = embed_data_matrix_encoding(encrypted_image, secret_data)

    # Second layer: Embed extra data using histogram shifting
    final_image = embed_data_histogram_shifting(encoded_image, secret_data)

    return final_image


# Full decoding process
def decode_image(encoded_image, secret_key=123):
    # In a real-world case, you'd first decode the histogram-shifted data, then matrix encoding, and finally reverse MSB prediction
    # Placeholder implementation for decoding
    return encoded_image


from PIL import Image

# Load image
image = np.array(Image.open("./fairycore-misty-forest-desktop-wallpaper.png"))

# Secret data to hide
secret_data = "Hello World".encode()

# Encode the image with secret data
encoded_image = encode_image(image, secret_data)

# Save the encoded image
Image.fromarray(encoded_image).save("encoded_image.png")

# Decode the image (placeholder function for now)
decoded_image = decode_image(encoded_image)
Image.fromarray(decoded_image).save("decoded_image.png")
