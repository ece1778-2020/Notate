from app import app
from flask import render_template, request, jsonify
import urllib.parse
import requests


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        shit = request.get_json(force=True)
        return render_template('index.html', shit=shit)
    return "???"
