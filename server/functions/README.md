## Setup

1. Clone the repository

2. Install the required dependencies:
    ```sh
    pip install -r requirements.txt
    ```

## Local Testing
```sh
firebase emulators:start
```

## Deployment
```sh
firebase deploy --only functions
```