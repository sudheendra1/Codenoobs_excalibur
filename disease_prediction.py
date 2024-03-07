import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import KFold
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential, load_model
from tensorflow.keras.layers import Dense, Dropout, BatchNormalization
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from flask import Flask, jsonify, request
from flask_cors import CORS
import csv
from joblib import dump, load
import matplotlib.pyplot as plt




data = pd.read_csv('dataset.csv', encoding='utf-8', header=0)
data = data.replace('\x1a', float('nan'))
#print(data.isnull().sum())

numeric_cols = data.select_dtypes(include=[np.number]).columns
means = data[numeric_cols].mean()
data[numeric_cols] = data[numeric_cols].fillna(means)
X = data.drop('prognosis', axis=1)
y = data['prognosis']
encoder = LabelEncoder()
y_encoded = encoder.fit_transform(y)

def plot_training_history(history):
    # summarize history for accuracy
    plt.figure(figsize=(12, 6))
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'])
    plt.plot(history.history['val_accuracy'])
    plt.title('model accuracy')
    plt.ylabel('accuracy')
    plt.xlabel('epoch')
    plt.legend(['train', 'validation'], loc='upper left')
    
    # summarize history for loss
    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('model loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'validation'], loc='upper left')
    plt.tight_layout()
    plt.show()

def train_and_save_models():
# Load the data

# K-Fold Cross Validation
 kf = KFold(n_splits=5, shuffle=True, random_state=42)
 fold_num = 0

 for train_index, test_index in kf.split(X):
    fold_num += 1
    print(f"Processing Fold {fold_num}")
    
    X_train, X_test = X.iloc[train_index], X.iloc[test_index]
    y_train_encoded, y_test_encoded = y_encoded[train_index], y_encoded[test_index]
    
    # Standardization
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # Random Forest Model
    rf = RandomForestClassifier(n_estimators=100, random_state=42)
    rf.fit(X_train, y_train_encoded)
    rf_probs = rf.predict_proba(X_test)

    # Neural Network Model
    model = Sequential()
    model.add(Dense(256, input_dim=X_train_scaled.shape[1], activation='relu'))
    model.add(BatchNormalization())
    model.add(Dropout(0.5))
    model.add(Dense(128, activation='relu'))
    model.add(BatchNormalization())
    model.add(Dropout(0.5))
    model.add(Dense(len(encoder.classes_), activation='softmax'))

    model.compile(loss='sparse_categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
   

    # Callbacks
    early_stopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
    model_checkpoint = ModelCheckpoint(f'best_model_fold_{fold_num}.h5', save_best_only=True)

    history= model.fit(X_train_scaled, y_train_encoded, epochs=100, batch_size=32, validation_split=0.2, callbacks=[early_stopping, model_checkpoint])
    plot_training_history(history)
    # Load the best saved model
    model = load_model(f'best_model_fold_{fold_num}.h5')
    nn_probs = model.predict(X_test_scaled)

    # Ensemble by averaging prediction probabilities
    final_probs = (rf_probs + nn_probs) / 2
    final_predictions = encoder.inverse_transform(final_probs.argmax(axis=1))

    print(f"Fold {fold_num} Ensemble Accuracy:", accuracy_score(encoder.inverse_transform(y_test_encoded), final_predictions))

# Feature Importance (After the last fold, for demonstration)
 importances = rf.feature_importances_
 indices = np.argsort(importances)[::-1]
 print("Feature ranking (Top 10):")
 for f in range(10):
    print("%d. feature %s (%f)" % (f + 1, X.columns[indices[f]], importances[indices[f]]))
    
 scaler = StandardScaler()
 X_scaled = scaler.fit_transform(X)

 rf = RandomForestClassifier(n_estimators=100, random_state=42)
 rf.fit(X_scaled, y_encoded)

 final_model = Sequential()
 final_model.add(Dense(256, input_dim=X_scaled.shape[1], activation='relu'))
 final_model.add(BatchNormalization())
 final_model.add(Dropout(0.5))
 final_model.add(Dense(128, activation='relu'))
 final_model.add(BatchNormalization())
 final_model.add(Dropout(0.5))
 final_model.add(Dense(len(encoder.classes_), activation='softmax'))
 final_model.compile(loss='sparse_categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

 final_model.fit(X_scaled, y_encoded, epochs=100, batch_size=32)
 final_model.save('final_model.h5')

# Load the saved model
 model = load_model('final_model.h5')
 dump(rf, 'random_forest_model.joblib')
 dump(scaler, 'scaler.joblib')
 dump(encoder, 'encoder.joblib')
 final_model.save('final_model.h5')

def predict_disease(symptoms_input, rf_model, nn_model, scaler, encoder):
    symptoms_vector = [0] * len(X.columns)
    symptoms_to_index = {symptom: idx for idx, symptom in enumerate(X.columns)}
    for symptom in symptoms_input:
        if symptom in symptoms_to_index:
            symptoms_vector[symptoms_to_index[symptom]] = 1
    # Convert input to dataframe
    df_input = pd.DataFrame([symptoms_vector], columns=X.columns)

    # Standardize the input for the neural network
    scaled_input = scaler.transform(df_input)

    # Get predictions
    rf_probs = rf_model.predict_proba(df_input)
    nn_probs = nn_model.predict(scaled_input)

    # Ensemble by averaging prediction probabilities
    final_probs = (rf_probs + nn_probs) / 2
    final_prediction = encoder.inverse_transform(final_probs.argmax(axis=1))

    return final_prediction[0]

def disease_desc(query):
    results = []
    with open('D:\\sudheendra\\School\\rizvi college\\mini pro\\pharmcare\\disease prediction\\disease_description.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if query.lower() in row['Disease'].lower():
                results.append(row)
    return results

def disease_prec(query):
    results = []
    with open('D:\\sudheendra\\School\\rizvi college\\mini pro\\pharmcare\\disease prediction\\disease_precaution.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if query.lower() in row['Disease'].lower():
                results.append(row)
    return results

def disease_doc(query):
    results = []
    with open('D:\\sudheendra\\School\\rizvi college\\mini pro\\pharmcare\\disease prediction\\Doctor_Versus_Disease.csv', 'r', encoding='ANSI') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if query.lower() in row['Drug Reaction'].lower():
                results.append(row)
    return results

def load_resources():
    rf = load('random_forest_model.joblib')
    scaler = load('scaler.joblib')
    encoder = load('encoder.joblib')
    model = load_model('final_model.h5')
    return rf, scaler, encoder, model

"""app = Flask(__name__)
CORS(app) 

@app.route('/predict', methods=['POST'])
def predict_disease_api():
    rf, scaler, encoder, model = load_resources()
    symptoms_input = request.json['symptoms']
    if not (4 <= len(symptoms_input) <= 6):
        return jsonify({"error": "Please provide between 4 to 6 symptoms."}), 400
    predicted_disease = predict_disease(symptoms_input, rf, model, scaler, encoder)
    disease_description=disease_desc(predicted_disease)
    disease_precaution= disease_prec(predicted_disease)
    disease_doctor=disease_doc(predicted_disease)
    print(disease_doctor,disease_description,disease_precaution)
    return jsonify({"disease": predicted_disease,"description": disease_description,"precaution": disease_precaution,"doctor":disease_doctor})

if __name__ == "__main__":
    app.run(host='0.0.0.0')"""




"""def get_user_input(symptoms_list):
    user_input_vector = {symptom: 0 for symptom in symptoms_list}

    print("Please enter any 6 symptoms you're experiencing:")

    for i in range(6):
        symptom = input(f"Symptom {i+1}: ").strip()
        if symptom in user_input_vector:
            user_input_vector[symptom] = 1
        else:
            print("Symptom not recognized. It will not be considered in the prediction.")

    return list(user_input_vector.values())

# Get user input
symptoms_input = get_user_input(X.columns)

# Predict disease
predicted_disease = predict_disease(symptoms_input, rf, model, scaler, encoder)
print(f"Based on your symptoms, you might have: {predicted_disease}")"""