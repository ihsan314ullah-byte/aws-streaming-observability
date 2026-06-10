from fastapi import FastAPI
import subprocess

app = FastAPI()

BASE = "/home/ubuntu/streaming-demo/scripts/status.sh"


# -----------------------
# HEALTH CHECK
# -----------------------
@app.get("/health")
def health():
    return {"status": "ok"}


# -----------------------
# STATUS (calls status script)
# -----------------------
@app.get("/status")
def status():
    result = subprocess.run(
        ["bash", BASE],
        capture_output=True,
        text=True
    )
    return {"output": result.stdout}


# -----------------------
# SIMPLE METRICS
# -----------------------
@app.get("/metrics")
def metrics():
    cpu = subprocess.getoutput("top -bn1 | grep 'Cpu(s)' | awk '{print $2+$4}'")
    mem = subprocess.getoutput("free -m | awk 'NR==2{printf \"%.2f\", $3*100/$2}'")
    ffmpeg = subprocess.getoutput("pgrep ffmpeg || echo 'not_running'")

    return {
        "cpu_percent": cpu,
        "memory_percent": mem,
        "ffmpeg": "running" if ffmpeg != "not_running" else "stopped"
    }
