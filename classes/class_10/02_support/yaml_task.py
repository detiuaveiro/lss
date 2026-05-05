import yaml

# Create config.yml for testing
config_content = {
    "app": {
        "name": "MyAwesomeApp",
        "version": "1.0.2"
    },
    "database": {
        "host": "localhost",
        "port": 5432
    },
    "debug": True
}

with open("config.yml", "w") as f:
    yaml.dump(config_content, f)

# Read and print
with open("config.yml", "r") as f:
    config = yaml.safe_load(f)
    app_name = config['app']['name']
    version = config['app']['version']
    port = config['database']['port']
    print(f"Running {app_name} version {version} on port {port}")
