# Shikane

Quick notes for using Shikane to apply display layouts.

## Config location

This repo keeps the config at:

- ~/.config/shikane/config.toml

## How it works

- The config defines one or more `profile` blocks.
- Each profile has one or more `profile.output` blocks that match displays via the `search` list.
- When a profile matches the currently connected displays, Shikane applies the output settings.

## Run it

From a terminal:

```sh
shikane -c ~/.config/shikane/config.toml
```

For help and additional flags:

```sh
shikane --help
```

## Common edits

- Add or remove a `[[profile.output]]` block to change a layout.
- Update `mode`, `position`, `scale`, or `transform` to tweak placement and rotation.
- Keep `search` values stable so outputs are identified correctly.
