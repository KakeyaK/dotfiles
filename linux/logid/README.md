# LogiOps (logid) via GNU Stow

This package manages /etc/logid.cfg with Stow and runs the logid service.

## Files
- etc/logid.cfg → /etc/logid.cfg

## Install (from repo root)
```bash
sudo stow -d linux -t / logid
```

## Enable and start
```bash
sudo systemctl enable --now logid
```

## Reload after edits
```bash
sudo systemctl restart logid
```

## View logs
```bash
sudo journalctl -u logid -f
```

## Validate config in foreground (debug)
```bash
sudo systemctl stop logid
sudo logid -v -c /etc/logid.cfg
# then Ctrl+C and:
sudo systemctl start logid
```

## Uninstall
```bash
sudo systemctl disable --now logid
sudo stow -d linux -t / -D logid
```

## Notes
- Ensure the device name in logid.cfg matches your mouse (e.g., "MX Master 3S").
- To list detected Logitech devices:
  ```bash
  sudo logid -l
  ```
- Sway bindings used by gestures:
  - Ctrl+Alt+Left → workspace prev_on_output
  - Ctrl+Alt+Right → workspace next_on_output