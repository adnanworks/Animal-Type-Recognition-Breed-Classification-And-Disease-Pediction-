




import os
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import layers, models
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.optimizers import Adam
from sklearn.utils import class_weight
import numpy as np

# -----------------------------
# Dataset path
# -----------------------------
dataset_dir = r"C:\Users\USER\Pictures\animal_species_dataset"
img_height, img_width = 224, 224
batch_size = 16

# -----------------------------
# Image preprocessing
# -----------------------------
datagen = ImageDataGenerator(
    rescale=1./255,
    validation_split=0.2,
    horizontal_flip=True,
    rotation_range=20,
    zoom_range=0.2
)

train_gen = datagen.flow_from_directory(
    dataset_dir,
    target_size=(img_height, img_width),
    batch_size=batch_size,
    class_mode='categorical',
    subset='training',
    shuffle=True
)

val_gen = datagen.flow_from_directory(
    dataset_dir,
    target_size=(img_height, img_width),
    batch_size=batch_size,
    class_mode='categorical',
    subset='validation'
)

# -----------------------------
# ⚠️ NEW — Compute class weights
# -----------------------------
class_weights = class_weight.compute_class_weight(
    class_weight='balanced',
    classes=np.unique(train_gen.classes),
    y=train_gen.classes
)

class_weights = dict(enumerate(class_weights))
print("Class Weights:", class_weights)

# -----------------------------
# Build model using Transfer Learning
# -----------------------------
base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(img_height, img_width, 3))
base_model.trainable = False

model = models.Sequential([
    base_model,
    layers.GlobalAveragePooling2D(),
    layers.Dense(128, activation='relu'),
    layers.Dropout(0.3),
    layers.Dense(train_gen.num_classes, activation='softmax')
])

model.compile(optimizer=Adam(1e-4), loss='categorical_crossentropy', metrics=['accuracy'])
model.summary()

# -----------------------------
# Train the model WITH class weights
# -----------------------------
epochs = 50
history = model.fit(
    train_gen,
    validation_data=val_gen,
    epochs=epochs,
    class_weight=class_weights     # <-- IMPORTANT
)

# -----------------------------
# Save the model
# -----------------------------
model.save(r"C:\Users\USER\Pictures\animal_species_dataset\spec_classifiernew2.h5")
print("Model saved successfully!")
