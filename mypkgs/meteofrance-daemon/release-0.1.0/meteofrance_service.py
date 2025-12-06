import json
import requests
from datetime import datetime, timedelta

PUBLIC_URL = "https://meteofrance.com/previsions-meteo-france/lyon/69000"
PUBLIC_HEADERS = {
    "Host": "meteofrance.com",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:145.0) Gecko/20100101 Firefox/145.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Referer": "https://duckduckgo.com/",
    "Sec-GPC": "1",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "cross-site",
}

class MeteofranceService:

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update(PUBLIC_HEADERS)

    def _request_private_api(self, url, **kwargs):
        # First request will always need to obtain a token first
        if 'Authorization' not in self.session.headers:
            self._obtain_token()
            
        # Optimistically attempt to dispatch reqest
        response = self.session.request("GET", url, **kwargs)
        if self._token_has_expired(response):
            # We got an 'Access token expired' response => refresh token
            self._obtain_token()
            # Re-dispatch the request that previously failed
            response = self.session.request("GET", url, **kwargs)

        return response

    def _token_has_expired(self, response):
        if response.status_code == 401:
            return True
        else:
            return False

    def _obtain_token(self):
        mfsession = self._get_mfsession_cookie()
        priv_token = self._transform_mfsession_to_priv_token(mfsession)
        self.session.headers.update({"Authorization": f"Bearer {priv_token}"})

    def _get_mfsession_cookie(self):
        # Get the main page
        tmp_session = requests.Session()
        tmp_session.headers.update(PUBLIC_HEADERS)
        res = tmp_session.get(PUBLIC_URL)

        cookie_raw = res.headers["Set-Cookie"]
        start_pos = 10
        end_pos = cookie_raw.find(";")
        return cookie_raw[start_pos:end_pos]

    def _transform_mfsession_to_priv_token(self, mfsession):
        priv_token = ""
        for char in mfsession:
            o = ord(char)
            if (o>=65 and o<=90) or (o>=97 and 0<=122):
                t = 65 if (o<=90) else 97
                new = t + (o-t+13)%26
                priv_token += chr(new)
            else:
                priv_token += char
        return priv_token
    
    def reset_session(self):
        del self.session
        self.session = requests.Session()
        self.session.headers.update(PUBLIC_HEADERS)

    def get_rain_in_next_hour(self, lat, lng):
        url = f"https://rwg.meteofrance.com/internet2018client/2.0/nowcast/rain?lat={lat}&lon={lng}"
        res = self._request_private_api(url)
        out = json.loads(res.text)["properties"]
        for prev in out["forecast"]:
            prev["time"] = datetime.strptime(prev["time"][:-5], "%Y-%m-%dT%H:%M:%S")
            prev["time"] += timedelta(hours=1) # Convertion to Paris time
        return out

    def get_weather_forecast(self, lat, lng):
        url = f"https://rwg.meteofrance.com/internet2018client/2.0/forecast/gp?lat={lat}&lon={lng}&id=&instants=morning%2Cafternoon%2Cevening%2Cnight&day=5"
        res = self._request_private_api(url)
        out = json.loads(res.text)["properties"]
        for prev in out["forecast"]:
            prev["time"] = datetime.strptime(prev["time"][:-5], "%Y-%m-%dT%H:%M:%S")
            # /!\ Night is given as next day
        return out
    
    def get_weather_now(self, lat, lng):
        url = f"https://rwg.meteofrance.com/internet2018client/2.0/observation/gridded?lat={lat}&lon={lng}&id="
        res = self._request_private_api(url)
        out = json.loads(res.text)["properties"]["gridded"]
        return out
    
    
    # def get_prev_par_heure(self, lat, lng):
    #     url = f"https://rwg.meteofrance.com/internet2018client/2.0/forecast/gp?lat={lat}&lon={lng}&id=&instants=&day=0"
    #     res = self._request_private_api(url)
    #     return json.loads(res.text)
    