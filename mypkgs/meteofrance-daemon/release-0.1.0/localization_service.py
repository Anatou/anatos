import json
import requests

API_KEY = "692d8d02af7a7522689102ywg957f11"

class LocalizationService:

    def __init__(self):
        self.session = requests.Session()
        self.ip = ""
        self.lat = 0
        self.lng = 0
        self.has_ip_changed = False

    def update_ip(self):
        ip_res = requests.get("https://api.ipify.org")
        if ip_res.status_code == 200:
            self.has_ip_changed = self.ip!=ip_res.text and self.ip!=""
            self.ip = ip_res.text
        else:
            self.has_ip_changed = False
            self.ip = "unknown"

    def update_localization(self, from_ip=True, city="", postal_code=""):
        self.update_ip()

        if from_ip:
            url = f"http://ip-api.com/json/{self.ip}"
            response = requests.get(url)
            if response.status_code == 200:
                data = json.loads(response.text)
                self.lat = data["lat"]
                self.lng = data["lon"]
            else:
                self.lat = 0
                self.lng = 0
        else:
            #https://geocode.maps.co/account/
            response = ""
            if postal_code != "":
                response = requests.get(f"https://geocode.maps.co/search?postalcode={postal_code.replace(" ", "+")}&api_key=692d8d02af7a7522689102ywg957f11")
            elif city != "":
                response = requests.get(f"https://geocode.maps.co/search?city={city.replace(" ", "+")}&api_key=692d8d02af7a7522689102ywg957f11")
            else:
                self.lat = 0
                self.lng = 0
                return
            
            if response.status_code == 200:
                data = json.loads(response.text)
                self.lat = data[0]["lat"]
                self.lng = data[0]["lon"]

        

    def get_lat(self):
        return self.lat
    def get_lng(self):
        return self.lng
    def get_has_ip_changed(self):
        return self.has_ip_changed
    def get_ip(self):
        return self.ip