import sys, os, time, atexit, signal, socket

class socket_daemon:
    """A generic daemon class communicating with a socket.

    Usage: subclass the daemon class and override the run() method."""

    def __init__(self, pidfile): 
        self.pidfile = pidfile
    
    def daemonize(self):
        """Deamonize class. UNIX double fork mechanism. (or fork-decouple-fork)"""

        print("daemonize")

        try: 
            pid = os.fork() 
            if pid > 0:
                # exit first parent
                sys.exit(0) 
        except OSError as err: 
            sys.stderr.write('fork #1 failed: {0}\n'.format(err))
            sys.exit(1)
    
        # decouple from parent environment
        os.chdir('/') 
        os.setsid() 
        os.umask(0) 
    
        # do second fork
        try: 
            pid = os.fork() 
            if pid > 0:

                # exit from second parent
                sys.exit(0) 
        except OSError as err: 
            sys.stderr.write('fork #2 failed: {0}\n'.format(err))
            sys.exit(1) 
    
        # redirect standard file descriptors
        
        sys.stdout.flush()
        sys.stderr.flush()
        
        si = open(os.devnull, "r")
        so = open(os.devnull, "a+")
        se = open(os.devnull, "a+")

        # os.dup2(si.fileno(), sys.stdin.fileno())
        # os.dup2(so.fileno(), sys.stdout.fileno())
        # os.dup2(se.fileno(), sys.stderr.fileno())
    
        # write pidfile
        atexit.register(self.close_daemon)

        pid = str(os.getpid())
        with open(self.pidfile,'w+') as f:
            f.write(pid + '\n')
    
    def start_socket(self):

        print("start_socket")

        self.sock = socket.socket()
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind(('localhost', 6000))
        self.sock.listen(5)

    def close_socket(self):

        print("close_socket")

        self.sock.close()

    def close_daemon(self):

        print("close_daemon")

        os.remove(self.pidfile)
        self.close_socket()

    def start(self):
        """Start the daemon."""

        print("start")

        # Check for a pidfile to see if the daemon already runs
        try:
            with open(self.pidfile,'r') as pf:
                pid = int(pf.read().strip())
        except IOError:
            pid = None
    
        if pid:
            message = "pidfile {0} already exist. " + \
                    "Daemon already running?\n"
            sys.stderr.write(message.format(self.pidfile))
            sys.exit(1)
        
        # Start the daemon
        self.daemonize()
        self.start_socket()
        self.prepare()
        while True: 
            # Establish connection with client. 
            s, addr = self.sock.accept() 
            self.get_message(s, addr)
            s.close()

        

    def stop(self):
        """Stop the daemon."""

        print("stop")

        # Get the pid from the pidfile
        try:
            with open(self.pidfile,'r') as pf:
                pid = int(pf.read().strip())
        except IOError:
            pid = None
    
        if not pid:
            message = "pidfile {0} does not exist. " + \
                    "Daemon not running?\n"
            sys.stderr.write(message.format(self.pidfile))
            return # not an error in a restart

        # Try killing the daemon process	
        try:
            while 1:
                os.kill(pid, signal.SIGTERM)
                time.sleep(0.1)
        except OSError as err:
            e = str(err.args)
            if e.find("No such process") > 0:
                if os.path.exists(self.pidfile):
                    os.remove(self.pidfile)
            else:
                print (str(err.args))
                sys.exit(1)

    def restart(self):
        """Restart the daemon."""

        print("restart")

        self.stop()
        self.start()

    def get_message(self, s, addr):
        """You should override this method when you subclass Daemon.
        
        It will be called for each message recived after has been daemonized by 
        start() or restart()."""
        
    def prepare(self):
        """You should override this method when you subclass Daemon.
        
        It will be called after the daemonization and the socket creation"""
