import tensorflow as tf

# Load the model
model = tf.keras.models.load_model("sign_interpreter_model.h5")

# Convert the model with additional flags
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Enable support for ops outside of the standard TFLite set
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS,
    tf.lite.OpsSet.SELECT_TF_OPS  # <-- This line adds support for LSTM and other complex ops
]

# Disable experimental lowering of tensor list ops (which fails with dynamic LSTM shapes)
converter._experimental_lower_tensor_list_ops = False

# Convert the model
tflite_model = converter.convert()

# Save the .tflite model
with open("sign_model.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ TFLite model converted and saved successfully.")
