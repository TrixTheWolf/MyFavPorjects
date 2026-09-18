import pandas as pd
import glob
import json
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from scipy.special import softmax
import os

# 1. Load your JSON Dictionary
try:
    with open('MarchMadnessAliases.json', 'r') as f:
        entity_dict = json.load(f)
except FileNotFoundError:
    print("Error: 'MarchMadnessAliases.json' not found in the current directory.")
    print(f"Current Directory: {os.getcwd()}")
    exit()

# 2. Load the RoBERTa Model
print("Loading model...")
MODEL = "cardiffnlp/twitter-roberta-base-sentiment-latest"
tokenizer = AutoTokenizer.from_pretrained(MODEL)
model = AutoModelForSequenceClassification.from_pretrained(MODEL)

# 3. Find all Excel files in the subfolder
subfolder = "ExcelSheets"
all_excel_files = glob.glob(f"{subfolder}/*.xlsx")

if not all_excel_files:
    print(f"No .xlsx files found in the '{subfolder}' directory.")
    exit()

# 4. Define the Analysis Logic
def analyze_entities_and_sentiment(text):
    text_str = str(text).lower()
    found_entities = []
    
    for team_name, data in entity_dict.items():
        # Combine aliases, coaches, and players into one search list
        search_terms = data.get("aliases", []) + data.get("coach", []) + data.get("players", [])
        ignore_terms = data.get("ignore_words", [])
        
        # Check if any search term is in the comment
        match_found = any(str(term).lower() in text_str for term in search_terms)
        
        # Check if we should ignore this comment (e.g., 'dog' for UConn)
        ignore_found = any(str(term).lower() in text_str for term in ignore_terms)
        
        if match_found and not ignore_found:
            found_entities.append(team_name)
    
    if not found_entities:
        return None, None
    
    # Run Sentiment Analysis
    encoded_input = tokenizer(text_str, return_tensors='pt', truncation=True, max_length=512)
    with torch.no_grad():
        output = model(**encoded_input)
    
    scores = softmax(output[0][0].numpy())
    labels = ['Negative', 'Neutral', 'Positive']
    sentiment = labels[scores.argmax()]
    
    return ",".join(found_entities), sentiment

# 5. Process Files
for file in all_excel_files:
    print(f"Processing {file}...")
    df = pd.read_excel(file)
    
    # Update this to match your EXACT column name in the Excel files
    text_column = 'Comment' 
    
    if text_column not in df.columns:
        print(f"Column '{text_column}' not found. Skipping {file}.")
        continue

    # Apply analysis
    results = df[text_column].apply(lambda x: pd.Series(analyze_entities_and_sentiment(x)))
    df['mentioned_teams'] = results[0]
    df['sentiment'] = results[1]
    
    # Save the analyzed file in the main folder
    output_name = f"analyzed_{os.path.basename(file)}"
    df.to_excel(output_name, index=False)
    print(f"Saved: {output_name}")

print("Batch processing complete!")