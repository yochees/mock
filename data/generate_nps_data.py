import csv
import random
from datetime import datetime, timedelta
import uuid

# Configuration
NUM_RECORDS = 15000
START_DATE = datetime(2025, 4, 1)
END_DATE = datetime(2025, 5, 31)

# Data templates
touchpoints = ['Email', 'Website', 'Support', 'Mobile App']
customer_segments = ['Enterprise', 'SMB', 'Consumer']

# Feedback templates for different scores
feedback_templates = {
    'high': [
        "Excellent product and service!",
        "Very satisfied with the experience.",
        "Great value for money.",
        "Outstanding support team.",
        "Best in class solution!",
        "Highly recommended!",
        "Exceeded our expectations.",
        "Very intuitive interface.",
        "Excellent ROI for our business.",
        "Transformative for our operations."
    ],
    'medium': [
        "Good product overall.",
        "Meets our basic needs.",
        "Decent performance.",
        "Could use some improvements.",
        "Generally satisfied.",
        "Works as expected.",
        "Average experience.",
        "Some features could be better.",
        "Satisfactory service.",
        "Good but room for improvement."
    ],
    'low': [
        "Needs significant improvement.",
        "Too expensive for what it offers.",
        "Not intuitive enough.",
        "Frequent issues and bugs.",
        "Poor customer support.",
        "Difficult to use.",
        "Not worth the price.",
        "Disappointed with the service.",
        "Too many problems.",
        "Would not recommend."
    ]
}

def generate_feedback(score):
    if score >= 8:
        return random.choice(feedback_templates['high'])
    elif score >= 5:
        return random.choice(feedback_templates['medium'])
    else:
        return random.choice(feedback_templates['low'])

def generate_customer_id():
    return f"C{random.randint(10000, 99999)}"

def generate_date():
    days_between = (END_DATE - START_DATE).days
    random_days = random.randint(0, days_between)
    return (START_DATE + timedelta(days=random_days)).strftime('%Y-%m-%d')

# Generate data
data = []
for i in range(1, NUM_RECORDS + 1):
    score = random.randint(1, 10)
    row = [
        i,  # response_id
        generate_date(),
        generate_customer_id(),
        score,
        generate_feedback(score),
        random.choice(touchpoints),
        random.choice(customer_segments)
    ]
    data.append(row)

# Write to CSV
with open('generated_nps_responses.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['response_id', 'date', 'customer_id', 'score', 'feedback', 'touchpoint', 'customer_segment'])
    writer.writerows(data)

print(f"Generated {NUM_RECORDS} records in generated_nps_responses.csv") 