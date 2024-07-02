## Setup

1. Clone the repository
2. Go to the functions directory:
    ```sh
    cd functions
    ```
3. Create a virtual environment:
    ```sh
    python -m venv venv
    ```
4. Activate the virtual environment:
    ```sh
    source venv/bin/activate
    ```

5. Install the required dependencies:
    ```sh
    pip install -r requirements.txt
    ```

## Local Testing
1. Add Google Gemini API Key to your environment variables or by adding it to the util/gemini_utils.py file:
    ```python
    genai.configure(api_key="YOUR_API_KEY")
    ```
    **Do not commit the API key to the repository.**

2. Go to the server directory:
    ```sh
    cd server
    ```
3. Start the Firebase emulators:
    ```sh
    firebase emulators:start
    ```

## Deployment
```sh
firebase deploy --only functions
```