# Core Ads

A job-based advertisement system for FiveM QBCore servers that allows whitelisted jobs to broadcast messages to all players with custom branding.

## Features

- **Job-Based Authorization** - Only specific jobs can send advertisements
- **Grade Requirements** - Set minimum job grades required to advertise
- **Custom Branding** - Each job displays with its own logo and label
- **Discord Webhook Logging** - Track all advertisements sent
- **Configurable Display** - Adjust display time and positioning
- **Beautiful UI** - Clean, modern interface with animated timer bar

## Requirements

- QBCore Framework

## Installation

1. Place the `core_ads` folder in your server's resources directory
2. Add `ensure core_ads` to your `server.cfg`
3. Add your logo images (PNG format) to the `html/images/` folder
4. Configure jobs and settings in `config.lua`
5. (Optional) Add your Discord webhook URL for logging

## Configuration

Edit `config.lua` to customize:

- **Display Time** - How long ads stay on screen (in milliseconds)
- **Webhook URL** - Discord webhook for logging advertisements
- **Allowed Jobs** - Configure which jobs can advertise with:
  - Job name
  - Display label
  - Logo filename (must be PNG in `html/images/`)
  - Minimum grade required

## Usage

Players with authorized jobs can use the command:

```
/ad [your message here]
```

**Example:**
```
/ad Come visit us for the best burgers in town!
```

The advertisement will be displayed to all players with the job's branding.

## Image Guidelines

- Use PNG format for all logos
- Keep all images the same size for consistency (recommended: 512x512 pixels)
- Place images in the `html/images/` folder
- Reference the exact filename in `config.lua`

## Support

For issues or questions, please contact the developer.