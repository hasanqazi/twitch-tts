import requests
import os
import time

def get_latest_release(repo):
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

def download_file(url, local_filename):
    print(f"Starting download from {url} to {local_filename}")
    with requests.get(url, stream=True) as response:
        response.raise_for_status()
        with open(local_filename, 'wb') as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
    print(f"Finished download to {local_filename}")
    return local_filename

def update_application(repo, target_files):
    try:
        latest_release = get_latest_release(repo)
        assets = latest_release['assets']
        
        script_dir = os.path.dirname(os.path.abspath(__file__))
        
        for asset in assets:
            if asset['name'] in target_files:
                download_url = asset['browser_download_url']
                download_path = os.path.join(script_dir, asset['name'])
                download_file(download_url, download_path)
                
                # Wait a bit to ensure the file is fully written
                time.sleep(2)
        
        print("All specified files have been downloaded.")
        
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    repo = "hasanqazi/twitch-tts"  # Replace with your GitHub repository
    target_files = ["SikeBot.console.exe", "SikeBot.exe", "SikeBot.pck"]
    
    update_application(repo, target_files)
