import numpy as np
from PIL import Image


def secret_data_to_bits(secret_data):
    secret_data_bytes = np.frombuffer(secret_data.encode("utf-8"), dtype=np.uint8)
    secret_data_bits = np.unpackbits(secret_data_bytes)
    return secret_data_bits


def msb_prediction(image):
    left = np.roll(image, 1, axis=1)
    top = np.roll(image, 1, axis=0)
    top_left = np.roll(np.roll(image, 1, axis=0), 1, axis=1)
    predicted_image = left * 0.33 + top * 0.33 + top_left * 0.33
    predicted_image = np.clip(predicted_image, 0, 255)
    return predicted_image.astype(np.uint8)


def matrix_encoding(block, data_bits):
    parity_matrix = np.array([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
    block = block[:3]
    syndrome = np.dot(block, parity_matrix.T) % 2
    if np.array_equal(syndrome, data_bits):
        return block
    else:
        for i in range(len(block)):
            modified_block = np.copy(block)
            modified_block[i] = 1 - block[i]
            if np.array_equal(np.dot(modified_block, parity_matrix.T) % 2, data_bits):
                return modified_block
    return block


def embed_data_msb(image, data_bits):
    flat_image = image.flatten()
    idx = 0
    predicted_image = msb_prediction(image)
    for i in range(len(predicted_image)):
        block = np.unpackbits(np.array([predicted_image[i]], dtype=np.uint8))[:3]
        if idx + 3 <= len(data_bits):
            encoded_block = matrix_encoding(block, data_bits[idx : idx + 3])
            packed_block = np.packbits(np.pad(encoded_block, (0, 5), constant_values=0))
            flat_image[i] = packed_block[0]
            idx += 3
    return flat_image.reshape(image.shape)


def histogram_shift(image_channel, data_bits):
    hist, bins = np.histogram(image_channel.flatten(), bins=256, range=(0, 255))
    min_bin = np.argmin(hist)
    shifted_channel = np.copy(image_channel)
    idx = 0
    for i in range(shifted_channel.shape[0]):
        for j in range(shifted_channel.shape[1]):
            pixel = shifted_channel[i, j]
            if idx < len(data_bits) and (pixel == min_bin or pixel == min_bin + 1):
                if data_bits[idx] == 1:
                    shifted_channel[i, j] += 1
                idx += 1
    return shifted_channel


def embed_data_histogram(image, data_bits):
    for channel in range(3):
        image[:, :, channel] = histogram_shift(image[:, :, channel], data_bits)
    return image


def reverse_histogram_shift(encoded_channel, data_length):
    extracted_bits = []
    flat_channel = encoded_channel.flatten()
    for i in range(data_length):
        extracted_bits.append(flat_channel[i] & 1)
    extracted_bytes = np.packbits(extracted_bits)
    return extracted_bytes


def decode_data_msb(image, data_length):
    flat_image = image.flatten()
    data_bits = []
    for i in range(0, data_length // 3):
        if i < len(flat_image):
            block = np.unpackbits(np.array([flat_image[i]], dtype=np.uint8))[:3]
            data_bits.extend(block)
    secret_data_bytes = np.packbits(data_bits[:data_length])
    return secret_data_bytes


image = np.array(Image.open("./fairycore-misty-forest-desktop-wallpaper.png"))
secret_data = "Hello World"
secret_data_bits = secret_data_to_bits(secret_data)
half_length = len(secret_data_bits) // 2
msb_data_bits = secret_data_bits[:half_length]
histogram_data_bits = secret_data_bits[half_length:]
encoded_image = embed_data_msb(image, msb_data_bits)
encoded_image = embed_data_histogram(encoded_image, histogram_data_bits)
encoded_img_pil = Image.fromarray(encoded_image)
encoded_img_pil.save("encoded_image.png")

data_length = len(histogram_data_bits)
extracted_histogram_data = reverse_histogram_shift(encoded_image[:, :, 0], data_length)
remaining_secret_data = decode_data_msb(encoded_image, len(msb_data_bits))
extracted_data_bits = np.concatenate((remaining_secret_data, extracted_histogram_data))
extracted_secret_data = extracted_data_bits.tobytes().decode("utf-8", errors="ignore")
print("Extracted secret data:", extracted_secret_data)
restored_img_pil = Image.fromarray(encoded_image)
restored_img_pil.save("restored_image.png")
