from weather_daemon import WeatherDaemon
import sys

def main():
    daemon = WeatherDaemon("/tmp/weather-daemon.pid")
    if len(sys.argv) == 2:
        if 'start' == sys.argv[1]:
            daemon.start()
            print("Daemon started")
        elif 'stop' == sys.argv[1]:
            daemon.stop()
            print("Daemon stopped")
        elif 'restart' == sys.argv[1]:
            daemon.restart()
            print("Daemon restarted")
        else:
            print("Unknown command")
            sys.exit(2)
        sys.exit(0)
    else:
        print("usage: %s start|stop|restart" % sys.argv[0])
        sys.exit(2)

if __name__ == '__main__':
    main()