# pk - portkill

Kill processes occupying a port. Handles process monitors that respawn children.

Works by escalating from graceful shutdown to parent hunting, ensuring ports actually get freed. Just run `pk 3000`.

## Installation

### Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/alchang/pk/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/alchang/pk.git
cd pk
make install
```

### Homebrew

```bash
brew tap alchang/tools
brew install pk
```

## Usage

```
pk [OPTIONS] <port>
```

## Options

```
-f, --force         Skip graceful shutdown, start with SIGKILL
-F, --ultra-force   Nuclear option - immediate sudo kill
-v, --verbose       Show detailed process information
-q, --quiet         Minimal output
-n, --no-parent     Don't hunt for parent processes
-d, --dry-run       Show what would be killed without doing it
-h, --help          Show help message
-V, --version       Show version
```

## Examples

```bash
pk 3000             # Kill whatever is on port 3000
pk -f 8080          # Force kill immediately
pk -v 3000          # Verbose output
pk -d 3000          # Dry run
pk -F 3000          # Nuclear option with sudo
```

## How It Works

Four escalating stages:

1. **SIGTERM** - Graceful shutdown (2s wait)
2. **SIGKILL** - Force kill (1s wait)
3. **Parent Hunt** - Kill monitor processes like nodemon
4. **Nuclear** - sudo kill everything

## Why

Development servers often leave processes on ports. Standard kill doesn't handle:
- Process monitors (nodemon, pm2) that respawn children
- Multiple processes on same port
- Orphaned child processes
- WebSocket connections that don't cleanup

pk handles all of these.

## Requirements

- bash 4.0+
- lsof
- Standard unix tools (ps, kill)

## License

MIT

## Author

Al Chang (@heyalchang at X/Twitter)