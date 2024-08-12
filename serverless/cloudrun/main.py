import os
import json
import functions_framework
from litellm import completion

# Load system message from file
def sys_reader():
    with open('sys.txt', 'r') as file:
        return file.read()

# Initialize the messages variable globally
messages = []

@functions_framework.http
def gemini_function(request):
    global messages

    # Parse the request JSON
    request_json = request.get_json(silent=True)
    
    # Check if 'prompt' and 'auth' are in the JSON
    if request_json is None or 'prompt' not in request_json or 'auth' not in request_json:
        return json.dumps({"error": "Invalid request: 'prompt' and 'auth' are required"}), 400
    
    prompt = request_json['prompt']
    os.environ['GEMINI_API_KEY'] = request_json['auth']

    # Reset memory if requested
    if 'reset memory' in prompt:
        messages = []
    elif not any(message["role"] == "system" for message in messages):
        # Add system message if none exists
        messages.append({
            "role": "system",
            "content": sys_reader()
        })

    # Append the user prompt
    messages.append({
        "role": "user",
        "content": prompt
    })

    # Call the Gemini model
    response = completion(
        model="gemini/gemini-pro",
        messages=messages
    )

    # Append the response message to the messages
    messages.append(response['choices'][0]['message'])

    response_content = response['choices'][0]['message']['content']

    result = {
        "choices": [
            {
                "message": {
                    "role": "assistant",
                    "content": response_content
                }
            }
        ]
    }

    return json.dumps(result), 200
