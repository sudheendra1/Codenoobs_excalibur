from joblib import  load
from flask import Flask, jsonify, request
from flask_cors import CORS
from tensorflow.keras.models import load_model
import csv
from disease_prediction import predict_disease

def load_resources():
    rf = load('random_forest_model.joblib')
    scaler = load('scaler.joblib')
    encoder = load('encoder.joblib')
    model = load_model('final_model.h5')
    return rf, scaler, encoder, model




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



app = Flask(__name__)
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
    app.run(host='0.0.0.0')
