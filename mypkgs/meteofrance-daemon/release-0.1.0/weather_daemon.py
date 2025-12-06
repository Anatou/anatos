from socket import socket
from datetime import datetime

from daemon import socket_daemon
from localization_service import LocalizationService
from meteofrance_service import MeteofranceService

import json

SYNC_COOLDOWN = 10
ICONS = {
    "Brouillard": "🌫️",
    "Ensoleillé": "☀️",
    "Ciel clair": "☀️",
    "Ciel voilé": "🌤️",
    "Eclaircies": "🌤️",
    "Peu nuageux": "⛅",
    "Très nuageux": "🌥️",
    "Couvert": "☁️",
    "Averses": "🌧️",
    "Pluie faible": "💧",
    "Pluie modérée": "💧",
    "Pluie": "💦",
    "Pluie et neige": "❄️/💧",
    1: "  ",
    2: "💧",
    3: "💦"
}

class WeatherDaemon(socket_daemon):

    def prepare(self):
        self.localization = LocalizationService()
        self.meteofrance_client = MeteofranceService()

        self.loc_lock = False

        self.city = {}
        self.rain = []
        self.forecast = []
        self.weather_now = {}
        self.last_updated = datetime(2000, 1, 1)

        self.localization.update_localization()
        self.update_weather()

    def update_weather(self):
        self.weather_now = self.meteofrance_client.get_weather_now(self.localization.get_lat(), self.localization.get_lng())
        infos_rain = self.meteofrance_client.get_rain_in_next_hour(self.localization.get_lat(), self.localization.get_lng())
        infos_forecast = self.meteofrance_client.get_weather_forecast(self.localization.get_lat(), self.localization.get_lng())
        self.city = {
            "name": infos_rain["name"],
            "country": infos_rain["country"],
            "altitude": infos_rain["altitude"],
            "french_department": infos_rain["french_department"],
            "timezone": infos_rain["timezone"],
        }
        self.rain = infos_rain["forecast"]
        self.forecast = infos_forecast["forecast"]
        self.last_updated = datetime.now()

    def get_message(self, s: socket, _):
        data = s.recv(100).decode().strip().split(" ")
        command = data[0]
        match command:
            # ================= GET ================= # 
            case "get-waybar":
                mes = json.dumps(self.format_for_waybar()).encode()
                s.send(mes)

            # ================= UPDATE ================= # 
            case "sync":
                # Prevent involuntary spamming
                if (datetime.now()-self.last_updated).total_seconds() > SYNC_COOLDOWN:
                    if not self.loc_lock: self.localization.update_localization()
                    else: self.localization.update_ip()

                    if self.localization.get_has_ip_changed():
                        self.meteofrance_client.reset_session()
                    self.update_weather()
                else:
                    print(f"Please wait {round(SYNC_COOLDOWN-(datetime.now()-self.last_updated).total_seconds())} seconds before syncing again...")


            # ================= MISC ================= # 
            case "set-city":
                if not self.loc_lock and len(data)>1:
                    self.localization.update_localization(from_ip=False, city=data[1])
                    self.update_weather()
            case "set-postcode":
                if not self.loc_lock and len(data)>1:
                    self.localization.update_localization(from_ip=False, postal_code=data[1])
                    self.update_weather()
            case "toggle-loc-lock":
                self.loc_lock = not self.loc_lock
            case "ping":
                s.send("pong".encode())

    def is_raining(self):
        if "pluie" in self.weather_now["weather_description"].lower():
            return True
        else:
            return False
        
    def _len_with_emoji(self, string: str):
        return len(string) + string.count("💧") + string.count("💦")

    def format_for_waybar(self) -> str:
        now = datetime.now()
        min_sync_resync = (now-self.last_updated).total_seconds()//60

        # ================== BAR TEXT ================== # 
        # Weather
        text_icon = ICONS.get(self.weather_now["weather_description"], self.weather_now["weather_description"]) 
        text_temp = round(self.weather_now["T"])
        text = f"{text_icon} {text_temp}°C"
        # Rain & Sync
        text_rain = ""
        if min_sync_resync < 45 and not self.is_raining():
            for r in self.rain:
                if r["time"]>now and r["rain_intensity"] > 1:
                    text_rain = f" | {ICONS.get(r["rain_intensity"], r["rain_intensity"])} in {int((r["time"]-now).total_seconds()//60)}min"
                    break
            if text_rain != "": text += text_rain
        else:
            text += " ⟲"
        
        # ================== TOOLTIP TEXT ================== # 
        tooltip_now = f"<big>Now</big> - {text_icon} {text_temp}°C <small>{self.weather_now["weather_description"]}</small>"
        tooltip_forecast_top = ""
        tooltip_forecast_mid = ""
        tooltip_forecast_bot = "<small>"
        i = 0
        while self.forecast[i]["time"]<now: i+=1 # Skip over obsolete prevs 
        for j in range(i,min(i+4,len(self.forecast))):
            # MID
            icon = ICONS.get(self.forecast[j]["weather_description"],self.forecast[j]["weather_description"])
            temp = round(self.forecast[j]["T"])
            section = f"{icon} {temp}°C │ "
            # TOP
            MOMENTS = {
                "matin": "MATIN",
                "après-midi": "APREM",
                "soirée": "SOIR",
                "nuit": "NUIT"
            }
            time_of_day = MOMENTS.get(self.forecast[j]["moment_day"],self.forecast[j]["moment_day"])
            weather_description = self.forecast[j]["weather_description"][:min(len(self.forecast[j]["weather_description"]), self._len_with_emoji(section))]

            # BOT
            tooltip_forecast_top += f"{time_of_day}" + " "*max(0,self._len_with_emoji(section)-len(time_of_day)-2) + "│ "
            tooltip_forecast_mid += section
            tooltip_forecast_bot += f"{weather_description}" + " "*max(0,self._len_with_emoji(section)-len(weather_description)) + f"</small>│ <small>"

        tooltip_forecast_top = tooltip_forecast_top[:-2] # Remove last "| "
        tooltip_forecast_mid = tooltip_forecast_mid[:-2] # Remove last "| "
        tooltip_forecast_bot = tooltip_forecast_bot[:-19] # Remove last "</small>│<small> "
        tooltip_forecast_bot += "</small>"

        tooltip_next_days = "<big>Next days</big>\n"
        tooltip_next_days += "MATIN  │ APREM  │ SOIR   │ NUIT\n"
        i = 0
        while self.forecast[i]["time"].day<=now.day: i+=1 # Skip over obsolete days 
        i+=1 # skip first night
        for _ in range(4):
            for j in range(i,min(i+4,len(self.forecast))):
                icon = ICONS.get(self.forecast[j]["weather_description"],self.forecast[j]["weather_description"])
                temp = round(self.forecast[j]["T"])
                tooltip_next_days += f"{icon} {temp}°C{" "*(2-len(str(temp)))}│ "
            tooltip_next_days = tooltip_next_days[:-2] + "\n"
            i+=4

        tooltip = ""
        tooltip +=  f"{tooltip_now}\n"
        tooltip +=  f"{tooltip_forecast_top}\n"
        tooltip +=  f"{tooltip_forecast_bot}\n"
        tooltip +=  f"{tooltip_forecast_mid}\n\n"
        tooltip +=  f"{tooltip_next_days}\n"
        tooltip +=  f"<small>Last updated {self.last_updated.strftime("%d/%m/%Y, %H:%M:%S")}</small>\n"
        tooltip += f"{self.city["name"]} - {self.city["country"]}"
        if self.loc_lock:
            tooltip += f" 🔒"

        # tooltip_rain = "Rain in hour "

        # for r in self.rain:
        #     if r["time"]>now:
        #         alt_rain_icon = ""
        #         match r["rain_intensity"]:
        #             case 1:
        #                 alt_rain_icon = "  "
        #             case 2:
        #                 alt_rain_icon = "💧"
        #             case 3:
        #                 alt_rain_icon = "💦"
        #             case _:
        #                 alt_rain_icon = r["rain_intensity"]
        #         tooltip_rain += f"|{alt_rain_icon}"
        
        return { "text": text, "alt": tooltip }