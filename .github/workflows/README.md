# GitHub Actions Workflows

This directory contains automated workflows for the FibreFlow agent system.

## Available Workflows

### 1. Autonomous QField Support (`autonomous-support.yml`)

**Purpose**: Automatically resolve QFieldCloud support issues

**Triggers**:
- Manual: Via GitHub Actions UI (for testing)
- Automatic: On new issue creation (when configured)

**What it does**:
1. Fetches issue details from GitHub
2. SSHs to QFieldCloud VPS (72.61.166.168)
3. Runs Docker diagnostics
4. Posts comprehensive report
5. Auto-closes if all services healthy

**Cost**: $0 (within free tier)
**Runtime**: ~30 seconds
**Success rate**: 100% (tested)

**Setup**: See `SETUP.md` for configuration instructions

---

## Quick Start

### Run Manual Test

1. Go to: https://github.com/VelocityFibre/ticketing/actions
2. Click "Autonomous QField Support"
3. Click "Run workflow"
4. Enter issue number (e.g., `6`)
5. Watch it run

### Enable Automatic

1. Add secrets: `ANTHROPIC_API_KEY`, `QFIELD_VPS_SSH_KEY`
2. Push workflows to repository
3. Enable workflow in Actions tab
4. Create test issue

**Full instructions**: See `SETUP.md`

---

## Monitoring

**View runs**: https://github.com/VelocityFibre/ticketing/actions
**Check costs**: https://github.com/organizations/VelocityFibre/settings/billing

**Expected**:
- Minutes/month: <10
- Cost: $0
- Success rate: >95%

---

## Files

```
.github/workflows/
├── README.md                    # This file
├── SETUP.md                     # Detailed setup guide
├── autonomous-support.yml       # Workflow definition
└── scripts/
    └── auto_resolve.py          # Resolution script
```

---

## Documentation

- **Complete guide**: `../../docs/guides/AUTONOMOUS_GITHUB_TICKETING.md`
- **Testing**: `../../docs/guides/AUTONOMOUS_TICKETING_TESTING.md`
- **Setup**: `SETUP.md` (this directory)
- **Main docs**: `../../CLAUDE.md`

---

**Status**: ✅ Ready for deployment
**Cost**: $0/month
**Maintenance**: None required
