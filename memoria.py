#!/usr/bin/env python3
import sqlite3
DB_PATH = "/data/data/com.termux/files/home/constellation-25/memoria.db"

class Memoria:
    def __init__(self):
        self.conn = sqlite3.connect(DB_PATH)
        self.conn.execute("CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY, agent TEXT, content TEXT, ts DATETIME DEFAULT CURRENT_TIMESTAMP)")
        self.conn.commit()

    def log(self, agent, content):
        self.conn.execute("INSERT INTO logs (agent, content) VALUES (?,?)", (agent, content))
        self.conn.commit()
