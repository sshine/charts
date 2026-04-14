set positional-arguments

# Vendor a single chart by name (e.g. just vendor alloy)
vendor name:
    #!/usr/bin/env python3
    import tomllib, subprocess, os, shutil, sys
    chart_key = "{{name}}"
    with open("charts.toml") as f:
        charts = tomllib.load(f)
    if chart_key not in charts:
        print(f"Unknown chart: {chart_key}")
        print(f"Available: {', '.join(sorted(charts))}")
        sys.exit(1)
    c = charts[chart_key]
    chart_name = c.get("chart", chart_key)
    chart_dir = os.path.join("charts", chart_name)
    if os.path.exists(chart_dir):
        shutil.rmtree(chart_dir)
    if "oci" in c:
        subprocess.run(["helm", "pull", "--untar", "-d", "charts/", "--version", c["version"], c["oci"]], check=True)
    else:
        subprocess.run(["helm", "pull", "--untar", "-d", "charts/", "--repo", c["repo"], "--version", c["version"], chart_name], check=True)
    print(f"  vendored {chart_key} -> charts/{chart_name}/")

# Vendor all charts from upstream
vendor-all:
    #!/usr/bin/env python3
    import tomllib, subprocess, os, shutil
    with open("charts.toml") as f:
        charts = tomllib.load(f)
    failed = []
    for name in sorted(charts):
        c = charts[name]
        chart_name = c.get("chart", name)
        chart_dir = os.path.join("charts", chart_name)
        if os.path.exists(chart_dir):
            shutil.rmtree(chart_dir)
        try:
            if "oci" in c:
                subprocess.run(["helm", "pull", "--untar", "-d", "charts/", "--version", c["version"], c["oci"]], check=True)
            else:
                subprocess.run(["helm", "pull", "--untar", "-d", "charts/", "--repo", c["repo"], "--version", c["version"], chart_name], check=True)
            print(f"  vendored {name}")
        except subprocess.CalledProcessError as e:
            print(f"  FAILED: {name}: {e}")
            failed.append(name)
    if failed:
        print(f"\nFailed: {', '.join(failed)}")
        sys.exit(1)

# Remove a vendored chart
remove name:
    #!/usr/bin/env python3
    import tomllib, shutil, os, sys
    chart_key = "{{name}}"
    with open("charts.toml") as f:
        charts = tomllib.load(f)
    c = charts.get(chart_key, {})
    chart_name = c.get("chart", chart_key)
    chart_dir = os.path.join("charts", chart_name)
    if os.path.exists(chart_dir):
        shutil.rmtree(chart_dir)
        print(f"  removed charts/{chart_name}/")
    else:
        print(f"  charts/{chart_name}/ not found")
