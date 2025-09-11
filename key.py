import google.generativeai as genai
import os

# The SDK will automatically look for the GOOGLE_API_KEY environment variable.
# Alternatively, you can configure it manually like this:
try:
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
except KeyError:
    print("Error: GOOGLE_API_KEY environment variable not set.")
    # Handle the error appropriately, e.g., exit or prompt the user.
    exit()


# Now you can use the API
model = genai.GenerativeModel('gemini-pro')
response = model.generate_content("Tell me a story about a friendly robot.")
print(response.text)
