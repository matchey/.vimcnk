#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import json
import urllib.parse
import importlib.util
import signal
from PyQt6.QtCore import *
# sudo apt install libxcb-xinerama0 libxcb-cursor0
from PyQt6.QtWidgets import QApplication, QMainWindow
# pip install PyQt6-WebEngine
from PyQt6.QtWebEngineWidgets import QWebEngineView
from PyQt6.QtNetwork import QNetworkProxyFactory
from http.server import HTTPServer, SimpleHTTPRequestHandler
import mistune

os.chdir(os.path.dirname(__file__) or '.')
signal.signal(signal.SIGINT, signal.SIG_DFL)

port = int(os.getenv("htmlpreview_port") or "8087")

QNetworkProxyFactory.setUseSystemConfiguration(True)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.webview = QWebEngineView(self)
        self.setCentralWidget(self.webview)
        self.setWindowTitle('Html Previewer')
        self.resize(1280, 980)
        self.webview.setUrl(QUrl(f"http://localhost:{port}"))

    def set_html_content(self, html):
        self.webview.setHtml(html)

class HtmlContentEvent(QEvent):
    def __init__(self, html):
        super().__init__(QEvent.Type(QEvent.registerEventType()))
        self.html = html

class PreviewHandler(SimpleHTTPRequestHandler):
    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length).decode('utf-8')
            p = urllib.parse.parse_qs(post_data)
            html_content = p["data"][0]
            html_with_css = f"""
            <html>
            <head>
                
            </head>
            <body>
                {html_content}
            </body>
            </html>
            """
            event = HtmlContentEvent(html_with_css)
            QApplication.postEvent(app, event)
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        except Exception as e:
            print(e)
            self.send_response(500)
            self.end_headers()
            self.wfile.write(f"Unexpected error: {e}".encode('utf-8'))

class WebServer(QThread):
    def __init__(self):
        super().__init__()
        self.server = HTTPServer(("", port), PreviewHandler)

    def run(self):
        self.server.serve_forever()

class App(QApplication):
    def __init__(self, argv):
        super().__init__(argv)
        self.main_window = MainWindow()
        self.main_window.show()

    def event(self, event):
        if isinstance(event, HtmlContentEvent):
            self.main_window.set_html_content(event.html)
            return True
        return super().event(event)

app = App(sys.argv)

server = WebServer()
server.start()

sys.exit(app.exec())
