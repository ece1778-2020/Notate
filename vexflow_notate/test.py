import requests

# r = requests.post('https://rc69q6tn5e.execute-api.us-east-1.amazonaws.com/dev', json={"notes": ["C#3/q, B2, A2/8, B2, C#3, D3"]})
r = requests.post('http://127.0.0.1:5000/', json={"notes": ["C#3/q, B2, A2/8, B2, C#3, D3", "C#3/q, B2, A2/8, B2, C#3, D3"]})
print(r.text)