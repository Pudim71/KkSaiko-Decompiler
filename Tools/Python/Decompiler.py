import os, subprocess, sys

def run_analyzers(script_dir, script_name, vh=None):
    analyzers_dir = os.path.join(script_dir, "Analyzers")
    if not os.path.exists(analyzers_dir):
        print(f"Analyzers directory not found: {analyzers_dir}")
        return
    
    scripts = sorted([f for f in os.listdir(analyzers_dir) if f.endswith(".py") and f != "Run_Dumpers.py"])
    for script in scripts:
        fp = os.path.join(analyzers_dir, script)
        print(f"\n{'=' * 60}")
        print(f"Running: {script}")
        print('=' * 60)
        try:
            subprocess.run(["python", fp, vh] if vh else ["python", fp], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    d = os.path.dirname(os.path.abspath(__file__))
    vh = sys.argv[1] if len(sys.argv) > 1 else None
    run_analyzers(d, os.path.abspath(__file__), vh)
